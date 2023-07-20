#!/usr/bin/env bash
#set -x

# Merritt Daily Build
#
# This script performs the following actions
# - Clone merritt-docker which contains submodules that link to all other Merritt code modules
# - Clone submodules
# - Checkout submoule branches identified in build-config.yml
# 
# Usage:
#   fresh_build.sh [merritt-docker branch] [build-config profile name]
#
# Environment variables
#   BUILDDIR - directory in which to run builds
#     if the build dir has a parent path containing "merritt-workspace/daily-builds", the directory will be deleted and recreated
#
# build-config.yml
# - "tags" determines the submodule branches to checkout for the build config
# - other values are flags that will determine the build steps to run
#
# Output Files
# - build-log.summary.txt           Overall summary of steps performed an the time it took to perform each step
# - build-log.git.txt               Git operation output
# - build-log.docker.txt            Docker build output
# - build-log.trivy-scan.txt        Trivy scan output
# - build-log.trivy-scan-fixed.txt  Trivy scan output excluding non fixable issues
# - build-log.maven.txt             Maven log ouput

is_daily_build_dir() {
  echo $WKDIR | grep -q "merritt-workspace\/daily-builds"
  if (( $? == 0 )); then echo 1; else echo 0; fi
}

create_working_dir() {
  if (( `is_daily_build_dir` ))
  then
    echo "Creating $WKDIR"
    rm -rf $WKDIR
    mkdir -p $WKDIR
  fi
  cd $WKDIR
}

get_jobstat(){ 
  if [ -e $JOBSTAT ]
  then
    cat $JOBSTAT
  fi
}

# eval_jobstat(status)
jobstat() {
  STATUS=`get_jobstat`
  if [ "$1" == "FAIL" ]
  then
    echo "FAIL" > $JOBSTAT
  elif [ "$1" == "WARN" ] && [ "$STATUS" != "FAIL" ]
  then
    echo "WARN" > $JOBSTAT
  elif [ "$STATUS" == "" ]
  then
    echo $1 > $JOBSTAT
  fi  
}

# eval_jobstat(return code, status, description)
eval_jobstat() {
  if [[ $1 > 0 ]]
  then
    jobstat "$2"
    echo "$3; Result: $1" >> $LOGSUM
  fi
}

init_log_files() {
  echo "See Log Ouput in $LOGSUM"

  echo "Working Dir: ${WKDIR}" > $LOGSUM
  echo " - ${LGOGIT}" >> $LOGGIT
  echo " - ${LOGDOCKER}" >> $LOGSUM
  echo " - ${LOGSUM}" >> $LOGSUM
  echo " - ${LOGSCAN}" >> $LOGSUM
  echo " - ${LOGSCANFIXED}" >> $LOGSUM
  echo " - ${LOGMAVEN}" >> $LOGSUM
  echo >> $LOGSUM

  echo > $LOGGIT
  echo > $LOGSCAN
  echo > $LOGDOCKER
  echo > $LOGMAVEN
  echo "Fixable items below.  See the attached report for the full vulnerability list: \n\n" > $LOGSCANFIXED
  jobstat "PASS" 

  echo "Build merritt-docker branch: ${MD_BRANCH} using build label ${BC_LABEL}" >> $LOGSUM
  echo >> $LOGSUM
  date >> $LOGSUM
}

environment_init() {
  # get dir of this script
  START_DIR=$(pwd)
  SCRIPT_HOME=$(dirname $0)
  DOCKER_ENV_FILE=$SCRIPT_HOME/docker_environment.sh

  # source env vars
  echo "Setting up docker environment" >> $LOGSUM
  [ -f "$DOCKER_ENV_FILE" ] && . "$DOCKER_ENV_FILE" || echo "file $DOCKER_ENV_FILE not found" >> $LOGSUM
  source ~/.profile.d/uc3-aws-util.sh

  echo "Setup ECS login" >> $LOGSUM
  echo "ECR_REGISTRY: $ECR_REGISTRY" >> $LOGSUM
  aws ecr get-login-password --region us-west-2 | \
    docker login --username AWS \
      --password-stdin ${ECR_REGISTRY} >> $LOGSUM 2>&1 || exit 1
}

checkout() {
  cd $WKDIR/merritt-docker
  SRCH=".[\"build-config\"].\"$BC_LABEL\".tags.\"$2\""
  branch=`python3 build-config.py|jq -r $SRCH`
  cd $WKDIR/merritt-docker/$1
  git checkout origin/$branch >> $LOGGIT 2>&1
  echo "checkout dir: $1, repo: $2, branch: $branch" >> $LOGSUM
}

scan_image() {
  if [ "$FLAG_SCAN" == "true" ]
  then
    trivy --scanners vuln image --severity CRITICAL --exit-code 100 $1 >> $LOGSCAN
    eval_jobstat $? "WARN" "Scan $1"
  else 
    echo "Scan disabled" >> $LOGSUM
  fi

  if [ "$FLAG_SCAN_UNFIXED" == "true" ]
  then
    trivy --scanners vuln image --severity CRITICAL  --exit-code 150 --ignore-unfixed $1 >> $LOGSCANFIXED 
    eval_jobstat $? "FAIL" "Scan (ignore unfixed) $1"
  else 
    echo "Scan unfixed disabled" >> $LOGSUM
  fi
}

build_image() {
  sleep 2
  echo >> $LOGSUM
  date >> $LOGSUM
  docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} --force-rm $3 -t $1 $2 >> $LOGDOCKER 2>&1 
  eval_jobstat $? "FAIL" "Docker build $1, dir: $2, param: $3"
  scan_image $1 
}

build_image_push() {
  build_image $1 $2 "$3"
  if [ "$FLAG_PUSH" == "true" ]
  then
    docker push $1 >> $LOGDOCKER 2>&1 
    eval_jobstat $? "FAIL" "Docker push $1"
  else 
    echo "Image push disabled" >> $LOGSUM
  fi
}

build_it_image() {
  echo >> $LOGSUM
  date >> $LOGSUM

  docker-compose -f $1 build --pull >> $LOGDOCKER 2>&1
  rc=$?
  if [ $rc -ne 0 ]; then echo "FAIL" > $JOBSTAT; fi 
  echo "Compose Build $2, file: $1; Result: $rc" >> $LOGSUM

  scan_image $2

  if [ "$FLAG_PUSH" == "true" ]
  then
    docker-compose -f $1 push >> $LOGDOCKER 2>&1
    eval_jobstat $? "FAIL" "Compose Push, file: $1"
  else 
    echo "Image push disabled" >> $LOGSUM
  fi
}

get_flag() {
  cd $WKDIR/merritt-docker
  python3 build-config.py|jq -r ".[\"build-config\"].\"$BC_LABEL\".\"$1\""
}

git_repo_init() {
  echo >> $LOGSUM
  echo "Clone merritt-docker; branch $MD_BRANCH" >> $LOGSUM
  echo "-----" >> $LOGSUM

  git clone git@github.com:CDLUC3/merritt-docker.git >> $LOGGIT 2>&1
  cd merritt-docker
  git checkout $MD_BRANCH >> $LOGGIT 2>&1
  git submodule update --remote --init >> $LOGGIT 2>&1

  echo >> $LOGSUM
  echo "Checking out sumbmodule branches for build label $BC_LABEL" >> $LOGSUM
  echo "-----" >> $LOGSUM

  checkout 'mrt-services/dep_core/mrt-core2' 'mrt-core'
  checkout 'mrt-services/dep_cloud/mrt-cloud' 'mrt-cloud'
  checkout 'mrt-services/dep_cdlzk/cdl-zk-queue' 'cdl-zk-queue'
  checkout 'mrt-services/dep_zoo/mrt-zoo' 'mrt-zoo'
  checkout 'mrt-services/inventory/mrt-inventory' 'mrt-inventory'
  checkout 'mrt-services/store/mrt-store' 'mrt-store'
  checkout 'mrt-services/ingest/mrt-ingest' 'mrt-ingest'
  checkout 'mrt-services/audit/mrt-audit' 'mrt-audit'
  checkout 'mrt-services/replic/mrt-replic' 'mrt-replic'
  checkout 'mrt-services/ui/mrt-dashboard' 'mrt-dashboard'
  checkout 'mrt-integ-tests' 'mrt-integ-tests'
}

build_integration_test_images() {
  echo >> $LOGSUM
  echo "Build Integration Test Docker Images" >> $LOGSUM
  echo "-----" >> $LOGSUM

  cd $WKDIR/merritt-docker/mrt-inttest-services

  build_it_image mock-merritt-it/docker-compose.yml ${ECR_REGISTRY}/mock-merritt-it:dev
  build_it_image mrt-it-database/docker-compose.yml ${ECR_REGISTRY}/mrt-it-database:dev
  build_it_image mrt-it-database/docker-compose-audit-replic.yml ${ECR_REGISTRY}/mrt-it-database-audit-replic:dev
  build_it_image mrt-minio-it/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it:dev
  build_it_image mrt-minio-it-with-content/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it-with-content:dev
}

build_maven_artifacts() {
  echo >> $LOGSUM
  echo "Run maven builds and integration tests" >> $LOGSUM
  echo "-----" >> $LOGSUM

  cd $WKDIR/merritt-docker/mrt-services

  if [ "$FLAG_RUN_MAVEN" == "true" ]
  then
    echo >> $LOGSUM
    date >> $LOGSUM
    mvn clean install -Pparent >> $LOGMAVEN 2>&1
    mvn clean install >> $LOGMAVEN 2>&1
    eval_jobstat $? "FAIL" "Maven Build"
  else 
    echo "Maven build disabled" >> $LOGSUM
  fi
}

build_microservice_images() {
  echo >> $LOGSUM
  echo "Build Merritt Images" >> $LOGSUM
  echo "-----" >> $LOGSUM

  cd $WKDIR/merritt-docker/mrt-services

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
}

build_docker_stack_support_images(){
  echo >> $LOGSUM
  echo "Build Docker Stack Images" >> $LOGSUM
  echo "-----" >> $LOGSUM

  cd $WKDIR/merritt-docker/mrt-services

  build_image_push ${ECR_REGISTRY}/mrt-database mysql
  build_image_push ${ECR_REGISTRY}/mrt-opendj ldap
  build_image_push ${ECR_REGISTRY}/mrt-init ldap
  build_image_push ${ECR_REGISTRY}/callback callback

  build_image ${ECR_REGISTRY}/logstash-oss:dev opensearch/logstash
}

build_merritt_lambda_images() {
  echo >> $LOGSUM
  echo "Build Merritt Lambda Images" >> $LOGSUM
  echo "-----" >> $LOGSUM

  cd $WKDIR/merritt-docker/mrt-services

  build_image_push ${ECR_REGISTRY}/mysql-ruby-lambda mrt-admin-lambda/mysql-ruby-lambda
  build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-common:dev mrt-admin-lambda/src-common
  build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-lambda:dev mrt-admin-lambda/src-admintool
  build_image_push ${ECR_REGISTRY}/uc3-mrt-colladmin-lambda:dev mrt-admin-lambda/src-colladmin
  build_image_push ${ECR_REGISTRY}/uc3-mrt-cognitousers:dev mrt-admin-lambda/cognito-lambda-nonvpc
  build_image_push ${ECR_REGISTRY}/simulate-lambda-alb mrt-admin-lambda/simulate-lambda-alb
}

build_merritt_end_to_end_test_images() {
  echo >> $LOGSUM
  echo "Build Merritt End to End Test Images" >> $LOGSUM
  echo "-----" >> $LOGSUM

  cd ../mrt-integ-tests
  build_image_push ${ECR_REGISTRY}/mrt-integ-tests .
  build_image standalone-chrome-download-folder chrome-driver
}

scan_default_docker_stack_support_images() {
  echo >> $LOGSUM
  echo "Scan Supporting Docker Stack Images" >> $LOGSUM
  date >> $LOGSUM

  scan_image zookeeper
  scan_image ghusta/fakesmtp
  scan_image opensearchproject/opensearch
  scan_image opensearchproject/opensearch-dashboards
}

post_summary_report() {
  echo >> $LOGSUM
  date >> $LOGSUM
  DIST=`get_ssm_value_by_name 'batch/email'`
  STATUS=`get_jobstat`
  cat $LOGSUM | mail -a $LOGSCAN -a $LOGSCANFIXED -s "${STATUS}: Merritt Daily Build and Docker Image Scan" ${DIST//,/}
  echo "${STATUS}: Merritt Daily Build and Docker Image Scan" >> $LOGSUM
}
# Process Runtime Args
MD_BRANCH=${1:-main}
BC_LABEL=${2:-main}
WKDIR=${BUILDDIR:-/apps/dpr2/merritt-workspace/daily-builds/${MD_BRANCH}.${BC_LABEL}}

create_working_dir

# Set ouput logs
LOGSUM=${WKDIR}/build-log.summary.txt
LOGGIT=${WKDIR}/build-log.git.txt
LOGDOCKER=${WKDIR}/build-log.docker.txt
LOGSCAN=${WKDIR}/build-log.trivy-scan.txt
LOGSCANFIXED=${WKDIR}/build-log.trivy-scan-fixed.txt
LOGMAVEN=${WKDIR}/build-log.maven.txt
JOBSTAT=${WKDIR}/jobstat.txt

init_log_files
environment_init

if (( `is_daily_build_dir` ))
then
  git_repo_init
fi

FLAG_PUSH=`get_flag push`
FLAG_SCAN=`get_flag scan-fixable`
FLAG_SCAN_UNFIXED=`get_flag scan-unfixable`
FLAG_RUN_MAVEN=`get_flag run-maven`

build_integration_test_images
build_maven_artifacts
build_microservice_images
build_docker_stack_support_images
build_merritt_lambda_images
build_merritt_end_to_end_test_images
scan_default_docker_stack_support_images
post_summary_report
