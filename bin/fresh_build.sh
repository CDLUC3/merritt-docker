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
#   fresh_build.sh [merritt-docker branch] [build-config profile name] [maven profile - optional]
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
    echo "Creating $WKDIR_PAR"
    rm -rf $WKDIR_PAR
    mkdir -p $WKDIR_PAR
  fi
  cd $WKDIR_PAR
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
    echo "* $2 $3; Result: $1" >> $LOGSUM
  else
    echo "       $3" >> $LOGSUM
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
  cd $WKDIR
  SRCH=".[\"build-config\"].\"$BC_LABEL\".tags.\"$2\""
  branch=`python3 build-config.py|jq -r $SRCH`
  cd $WKDIR/$1
  git checkout origin/$branch >> $LOGGIT 2>&1
  echo "checkout dir: $1, repo: $2, branch: $branch" >> $LOGSUM
}

scan_image() {
  if [ "$FLAG_SCAN" == "true" ]
  then
    trivy --scanners vuln image --severity CRITICAL --exit-code 100 $1 >> $LOGSCAN 2>&1
    eval_jobstat $? "WARN" "Scan $1"
  else 
    echo "       Scan disabled" >> $LOGSUM
  fi

  if [ "$FLAG_SCAN_UNFIXED" == "true" ]
  then
    trivy --scanners vuln image --severity CRITICAL  --exit-code 150 --ignore-unfixed $1 >> $LOGSCANFIXED 2>&1
    eval_jobstat $? "FAIL" "Scan (ignore unfixed) $1"
  else 
    echo "       Scan unfixed disabled" >> $LOGSUM
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
    echo "       Image push disabled" >> $LOGSUM
  fi
}

build_it_image() {
  echo >> $LOGSUM
  date >> $LOGSUM

  docker-compose -f $1 build --pull >> $LOGDOCKER 2>&1
  eval_jobstat $? "FAIL" "Compose Build $2, file: $1"

  scan_image $2

  if [ "$FLAG_PUSH" == "true" ]
  then
    docker-compose -f $1 push >> $LOGDOCKER 2>&1
    eval_jobstat $? "FAIL" "Compose Push, file: $1"
  else 
    echo "       Image push disabled" >> $LOGSUM
  fi
}

get_flag() {
  cd $WKDIR
  python3 build-config.py|jq -r ".[\"build-config\"].\"$BC_LABEL\".\"$1\""
}

# show_header(text, detail_log_path)
show_header() {
  echo >> $LOGSUM
  echo "$1 (log: `basename $2`)" >> $LOGSUM
  echo "-----" >> $LOGSUM
}

git_repo_init() {
  show_header "Clone merritt-docker; branch $MD_BRANCH" $LOGGIT
  cd $WKDIR_PAR
  git clone git@github.com:CDLUC3/merritt-docker.git >> $LOGGIT 2>&1
  cd $WKDIR
  git checkout $MD_BRANCH >> $LOGGIT 2>&1
}

git_repo_submodules() {
  git submodule update --remote --init >> $LOGGIT 2>&1
  show_header "Checking out sumbmodule branches for build label $BC_LABEL" $LOGGIT

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
  show_header "Build Integration Test Docker Images" $LOGDOCKER

  cd $WKDIR/mrt-inttest-services

  build_it_image mock-merritt-it/docker-compose.yml ${ECR_REGISTRY}/mock-merritt-it:dev
  build_it_image mrt-it-database/docker-compose.yml ${ECR_REGISTRY}/mrt-it-database:dev
  build_it_image mrt-it-database/docker-compose-audit-replic.yml ${ECR_REGISTRY}/mrt-it-database-audit-replic:dev
  build_it_image mrt-minio-it/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it:dev
  build_it_image mrt-minio-it-with-content/docker-compose.yml ${ECR_REGISTRY}/mrt-minio-it-with-content:dev
}

build_maven_artifacts() {
  show_header "Run maven builds and integration tests" $LOGMAVEN

  cd $WKDIR/mrt-services

  if [ "$FLAG_RUN_MAVEN_TESTS" == "true" ] || [ "$FLAG_RUN_MAVEN" == "true" ]
  then
    echo >> $LOGSUM
    date >> $LOGSUM

    mvn clean install -f dep_core/mrt-core2/pom.xml -Pparent >> $LOGMAVEN 2>&1
    if [ "$FLAG_RUN_MAVEN_TESTS" == "true" ]
    then
      mvn clean install $MAVEN_PROFILE >> $LOGMAVEN 2>&1
    else
      mvn clean install -Ddocker.skip -DskipITs -Dmaven.test.skip=true $MAVEN_PROFILE >> $LOGMAVEN 2>&1
    fi
    eval_jobstat $? "FAIL" "Maven Build"
  else 
    echo "       Maven build disabled" >> $LOGSUM
  fi
}

build_microservice_images() {
  show_header "Build Merritt Images" $LOGDOCKER

  cd $WKDIR/mrt-services

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
  show_header "Build Docker Stack Images" $LOGDOCKER

  cd $WKDIR/mrt-services

  build_image_push ${ECR_REGISTRY}/mrt-database mysql
  build_image_push ${ECR_REGISTRY}/mrt-opendj ldap
  build_image_push ${ECR_REGISTRY}/mrt-init ldap
  build_image_push ${ECR_REGISTRY}/callback callback

  build_image ${ECR_REGISTRY}/logstash-oss:dev opensearch/logstash
}

build_merritt_lambda_images() {
  show_header "Build Merritt Lambda Images" $LOGDOCKER

  cd $WKDIR/mrt-services

  build_image_push ${ECR_REGISTRY}/mysql-ruby-lambda mrt-admin-lambda/mysql-ruby-lambda
  build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-common:dev mrt-admin-lambda/src-common
  build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-lambda:dev mrt-admin-lambda/src-admintool
  build_image_push ${ECR_REGISTRY}/uc3-mrt-colladmin-lambda:dev mrt-admin-lambda/src-colladmin
  build_image_push ${ECR_REGISTRY}/uc3-mrt-cognitousers:dev mrt-admin-lambda/cognito-lambda-nonvpc
  build_image_push ${ECR_REGISTRY}/simulate-lambda-alb mrt-admin-lambda/simulate-lambda-alb
}

build_merritt_end_to_end_test_images() {
  show_header "Build Merritt End to End Test Images" $LOGDOCKER

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
  SUBJ="${STATUS}: Merritt Daily Build $MD_BRANCH - $BC_LABEL - ${MAVEN_PROFILE_PARAM}"
  cat $LOGSUM | mail -a $LOGSCAN -a $LOGSCANFIXED -s "$SUBJ" ${DIST//,/}
  echo $SUBJ
}

which mvn
mvn --version
exit

# Process Runtime Args
MD_BRANCH=${1:-main}
BC_LABEL=${2:-main}

# use "" or "uc3" to build all; otherwise "ingest", "inventory", "store", "audit", "replic"
MAVEN_PROFILE_PARAM=$3
if [ "$3" == "" ]; then MAVEN_PROFILE=""; else MAVEN_PROFILE="-P$3"; fi

WKDIR=${BUILDDIR:-/apps/dpr2/merritt-workspace/daily-builds/${MD_BRANCH}.${BC_LABEL}/merritt-docker}
# Note that Jenkins clones into a directory without repeating the repo name
WKDIR_PAR=${BUILDDIR:-/apps/dpr2/merritt-workspace/daily-builds/${MD_BRANCH}.${BC_LABEL}}

create_working_dir

# Set ouput logs
LOGSUM=${WKDIR_PAR}/build-log.summary.txt
LOGGIT=${WKDIR_PAR}/build-log.git.txt
LOGDOCKER=${WKDIR_PAR}/build-log.docker.txt
LOGSCAN=${WKDIR_PAR}/build-log.trivy-scan.txt
LOGSCANFIXED=${WKDIR_PAR}/build-log.trivy-scan-fixed.txt
LOGMAVEN=${WKDIR_PAR}/build-log.maven.txt
JOBSTAT=${WKDIR_PAR}/jobstat.txt

init_log_files
environment_init

if (( `is_daily_build_dir` )) 
then
  git_repo_init
  git_repo_submodules
elif [ "$JENKINS_HOME" != "" ]
then
  sed -i -e "s/git@github.com:/https:\/\/github.com\//" .git/config
  git_repo_submodules
fi

show_flags() {
  echo >> $LOGSUM
  echo "FLAG_PUSH=$FLAG_PUSH" >> $LOGSUM
  echo "FLAG_SCAN=$FLAG_SCAN" >> $LOGSUM
  echo "FLAG_SCAN_UNFIXED=$FLAG_SCAN_UNFIXED" >> $LOGSUM
  echo "FLAG_RUN_MAVEN=$FLAG_RUN_MAVEN" >> $LOGSUM
  echo "FLAG_RUN_MAVEN_TESTS=$FLAG_RUN_MAVEN_TESTS" >> $LOGSUM
  echo "FLAG_BUILD_SUPPORT=$FLAG_BUILD_SUPPORT" >> $LOGSUM
}

FLAG_PUSH=`get_flag push`
FLAG_SCAN=`get_flag scan-fixable`
FLAG_SCAN_UNFIXED=`get_flag scan-unfixable`
FLAG_RUN_MAVEN=`get_flag run-maven`
FLAG_RUN_MAVEN_TESTS=`get_flag run-maven-tests`
FLAG_BUILD_SUPPORT=`get_flag build-support`
show_flags

build_integration_test_images
build_maven_artifacts
build_microservice_images
build_docker_stack_support_images

if [ "$FLAG_BUILD_SUPPORT" == "true" ]
then
  build_merritt_lambda_images
  build_merritt_end_to_end_test_images
  scan_default_docker_stack_support_images
fi
post_summary_report
