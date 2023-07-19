#!/usr/bin/env bash
#set -x

MD_BRANCH=${1:-main}
BC_LABEL=${2:-main}

LOGSUM=/tmp/build-summary.${MD_BRANCH}.${BC_LABEL}.txt
LOGSCAN=/tmp/trivy-scan.${MD_BRANCH}.${BC_LABEL}.txt
LOGSCANFIXED=/tmp/trivy-scan-fixed.${MD_BRANCH}.${BC_LABEL}.txt
JOBSTAT=/tmp/jobstat.${MD_BRANCH}.${BC_LABEL}.txt

echo > $LOGSUM
echo > $LOGSCAN
echo "Fixable items below.  See the attached report for the full vulnerability list: \n\n">  $LOGSCANFIXED
echo "PASS" > $JOBSTAT

WKDIR=/apps/dpr2/merritt-workspace/builds

echo "Build merritt-docker branch: ${MD_BRANCH} using build label ${BC_LABEL}" >> $LOGSUM
echo >> $LOGSUM
date >> $LOGSUM

get_flag() {
  python3 build-config.py|jq -r ".[\"build-config\"].\"$BC_LABEL\".\"$1\""
}

FLAG_PUSH=`get_flag push`
FLAG_SCAN=`get_flag scan-fixable`
FLAG_SCAN_UNFIXED=`get_flag scan-unfixable`
FLAG_RUN_MAVEN=`get_flag run-maven`

checkout() {
  cd $WKDIR/merritt-docker
  SRCH=".[\"build-config\"].\"$BC_LABEL\".tags.\"$2\""
  branch=`python3 build-config.py|jq -r $SRCH`
  cd $WKDIR/merritt-docker/mrt-services/$1
  git checkout origin/$branch
  echo "checkout dir: $1, repo: $2, branch: $branch" >> $LOGSUM
}

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)
DOCKER_ENV_FILE=$SCRIPT_HOME/docker_environment.sh

# source env vars
echo "Setting up docker environment"
[ -f "$DOCKER_ENV_FILE" ] && . "$DOCKER_ENV_FILE" || echo "file $DOCKER_ENV_FILE not found"
source ~/.profile.d/uc3-aws-util.sh

echo "Setup ECS login"
echo "ECR_REGISTRY: $ECR_REGISTRY"
aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY} || exit 1

rm -rf $WKDIR
mkdir -p $WKDIR
cd $WKDIR
pwd

git clone git@github.com:CDLUC3/merritt-docker.git
cd merritt-docker
git submodule update --remote --init

echo "Setup ECS login"
echo "ECR_REGISTRY: $ECR_REGISTRY"
aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY} || exit 1

checkout 'dep_core/mrt-core2' 'mrt-core'
checkout 'dep_cloud/mrt-cloud' 'mrt-cloud'
checkout 'dep_cdlzk/cdl-zk-queue' 'cdl-zk-queue'
checkout 'dep_zoo/mrt-zoo' 'mrt-zoo'
checkout 'inventory/mrt-inventory' 'mrt-inventory'
checkout 'store/mrt-store' 'mrt-store'
checkout 'ingest/mrt-ingest' 'mrt-ingest'
checkout 'audit/mrt-audit' 'mrt-audit'
checkout 'replic/mrt-replic' 'mrt-replic'
checkout 'ui/mrt-dashboard' 'mrt-dashboard'
checkout 'mrt-integ-tests' 'mrt-integ-tests'

scan_image() {
  if [ "$FLAG_SCAN" == "true" ]
  then
    trivy --scanners vuln image --severity CRITICAL --exit-code 100 $1 >> $LOGSCAN
    rc=$?
    if [ $rc -ne 0 ]; then echo "WARN" > $JOBSTAT; fi
    echo "Scan $1; Result: $rc" >> $LOGSUM
  else 
    echo "Scan disabled" >> $LOGSUM
  fi

  if [ "$FLAG_SCAN_UNFIXED" == "true" ]
  then
    trivy --scanners vuln image --severity CRITICAL  --exit-code 150 --ignore-unfixed $1 >> $LOGSCANFIXED 
    rc=$?
    if [ $rc -ne 0 ]; then echo "FAIL" > $JOBSTAT; fi
    echo "Scan (ignore unfixed) $1; Result: $rc" >> $LOGSUM
  else 
    echo "Scan unfixed disabled" >> $LOGSUM
  fi
}

build_image() {
  sleep 2
  echo >> $LOGSUM
  date >> $LOGSUM
  docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} --force-rm $3 -t $1 $2 
  rc=$?
  if [ $rc -ne 0 ]; then echo "FAIL" > $JOBSTAT; fi
  echo "Docker build $1, dir: $2, param: $3; Result: $rc" >> $LOGSUM
  scan_image $1 
}

build_image_push() {
  build_image $1 $2 "$3"
  if [ "$FLAG_PUSH" == "true" ]
  then
    docker push $1 
    rc=$?
    if [ $rc -ne 0 ]; then echo "FAIL" > $JOBSTAT; fi
    echo "Docker push $1; Result: $rc" >> $LOGSUM
  else 
    echo "Image push disabled" >> $LOGSUM
  fi
}

build_it_image() {
  echo >> $LOGSUM
  date >> $LOGSUM

  docker-compose -f $1 build --pull
  rc=$?
  if [ $rc -ne 0 ]; then echo "FAIL" > $JOBSTAT; fi 
  echo "Compose Build $2, file: $1; Result: $rc" >> $LOGSUM

  scan_image $2

  if [ "$FLAG_PUSH" == "true" ]
  then
    docker-compose -f $1 push 
    rc=$?
    if [ $rc -ne 0 ]; then echo "FAIL" > $JOBSTAT; fi
    echo "Compose Push, file: $1; Result: $rc" >> $LOGSUM
  else 
    echo "Image push disabled" >> $LOGSUM
  fi
}

cd $WKDIR/merritt-docker/mrt-inttest-services

build_it_image mock-merritt-it/docker-compose.yml ${ECR_REGISTRY}/mock-merritt-it:dev
build_it_image mrt-it-database/docker-compose.yml ${ECR_REGISTRY}/mrt-it-database:dev
build_it_image mrt-it-database/docker-compose-audit-replic.yml ${ECR_REGISTRY}/mrt-it-database-audit-replic:dev
build_it_image mrt-minio-it/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it:dev
build_it_image mrt-minio-it-with-content/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it-with-content:dev

cd ../mrt-services

if [ "$FLAG_RUN_MAVEN" == "true" ]
then
  echo >> $LOGSUM
  date >> $LOGSUM
  mvn clean install -Pparent
  mvn clean install
  rc=$?
  if [ $rc -ne 0 ]; then STATUS='FAIL'; fi
  echo "Maven Build; Result: $rc" >> $LOGSUM
else 
  echo "Maven build disabled" >> $LOGSUM
fi

build_image_push ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn
build_image_push ${ECR_REGISTRY}/mrt-core2:dev dep_core
build_image_push ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk
build_image_push ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo
build_image_push ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud
build_image_push ${ECR_REGISTRY}/mrt-ingest:dev ingest
build_image_push ${ECR_REGISTRY}/mrt-inventory-src:dev inventory "-f inventory/Dockerfile-jar"
build_image_push ${ECR_REGISTRY}/mrt-inventory:dev inventory
build_image_push ${ECR_REGISTRY}/mrt-store:dev store
build_image_push ${ECR_REGISTRY}/mrt-audit:dev audit
build_image_push ${ECR_REGISTRY}/mrt-replic:dev replic

build_image_push ${ECR_REGISTRY}/mrt-dashboard ui
build_image_push ${ECR_REGISTRY}/mrt-database mysql
build_image_push ${ECR_REGISTRY}/mrt-opendj ldap
build_image_push ${ECR_REGISTRY}/mrt-init ldap
build_image_push ${ECR_REGISTRY}/callback callback

build_image_push ${ECR_REGISTRY}/mysql-ruby-lambda mrt-admin-lambda/mysql-ruby-lambda
build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-common:dev mrt-admin-lambda/src-common
build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-lambda:dev mrt-admin-lambda/src-admintool
build_image_push ${ECR_REGISTRY}/uc3-mrt-colladmin-lambda:dev mrt-admin-lambda/src-colladmin
build_image_push ${ECR_REGISTRY}/uc3-mrt-cognitousers:dev mrt-admin-lambda/cognito-lambda-nonvpc
build_image_push ${ECR_REGISTRY}/simulate-lambda-alb mrt-admin-lambda/simulate-lambda-alb

build_image ${ECR_REGISTRY}/logstash-oss:dev opensearch/logstash

cd ../mrt-integ-tests
build_image_push ${ECR_REGISTRY}/mrt-integ-tests .
build_image standalone-chrome-download-folder chrome-driver

echo >> $LOGSUM
date >> $LOGSUM
scan_image zookeeper
scan_image ghusta/fakesmtp
scan_image opensearchproject/opensearch
scan_image opensearchproject/opensearch-dashboards

echo >> $LOGSUM
date >> $LOGSUM
DIST=`get_ssm_value_by_name 'batch/email'`
STATUS=`cat $JOBSTAT`
cat $LOGSUM | mail -a $LOGSCAN -a $LOGSCANFIXED -s "${STATUS}: Merritt Daily Build and Docker Image Scan" ${DIST//,/}
echo "${STATUS}: Merritt Daily Build and Docker Image Scan"
rm $LOGSUM $LOGSCAN $LOGSCANFIXED