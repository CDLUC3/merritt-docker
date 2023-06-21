#!/usr/bin/env bash
#set -x

MD_BRANCH=main
BC_LABEL=opensearch
WKDIR=/apps/dpr2/merritt-workspace/builds

checkout() {
  cd $WKDIR/merritt-docker
  SRCH=".[\"build-config\"].\"$BC_LABEL\".tags.\"$2\""
  echo $SRCH
  branch=`python3 build-config.py|jq -r $SRCH`
  echo $branch
  cd $WKDIR/merritt-docker/mrt-services/$1
  git checkout origin/$branch
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

cd $WKDIR/merritt-docker/mrt-services

scan_image() {
  trivy --scanners vuln image --severity CRITICAL $1 >> /tmp/trivy-scan.txt
  trivy --scanners vuln image --severity CRITICAL --ignore-unfixed >> /tmp/trivy-scan-fixed.txt $1 || exit 1
}

build_image() {
  echo
  echo "Building $1 (dir $2)"
  echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} $3 -t $1 $2"
  sleep 2
  docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} --force-rm $3 -t $1 $2 || exit 1
  scan_image $1 
}

build_image_push() {
  build_image $1 $2 "$3"
  docker push $1 || exit 1
}

build_it_image() {
  echo
  echo "Building $2"
  docker-compose -f $1 build --pull || exit 1
  scan_image $2
  docker-compose -f $1 push || exit 1
}

echo > /tmp/trivy-scan.txt
echo "Fixable items below.  See the attached report for the full vulnerability list: \n\n"> /tmp/trivy-scan-fixed.txt

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

cd ../mrt-inttest-services

build_it_image mock-merritt-it/docker-compose.yml ${ECR_REGISTRY}/mock-merritt-it:dev
build_it_image mrt-it-database/docker-compose.yml ${ECR_REGISTRY}/mrt-it-database:dev
build_it_image mrt-it-database/docker-compose-audit-replic.yml ${ECR_REGISTRY}/mrt-it-database-audit-replic:dev
build_it_image mrt-minio-it/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it:dev
build_it_image mrt-minio-it-with-content/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it-with-content:dev
build_it_image pm-server/docker-compose.yml ${ECR_REGISTRY}/pm-server:dev

cd ../mrt-integ-tests
build_image_push ${ECR_REGISTRY}/mrt-integ-tests .
build_image standalone-chrome-download-folder chrome-driver

scan_image zookeeper
scan_image ghusta/fakesmtp
scan_image opensearchproject/opensearch
scan_image opensearchproject/opensearch-dashboards
scan_image opensearchproject/logstash-oss-with-opensearch-output-plugin

DIST=`get_ssm_value_by_name 'batch/email'`
cat /tmp/trivy-scan-fixed.txt | mail -a /tmp/trivy-scan.txt -s "Merritt Docker Image Scan" ${DIST//,/}