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
#   see usage()
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
  return $?
}

create_working_dir() {
  if is_daily_build_dir
  then
    echo "Creating $WKDIR_PAR"
    rm -rf $WKDIR_PAR
    mkdir -p $WKDIR_PAR
  fi
  cd $WKDIR_PAR

  if [[ -f $WKDIR/build-output/*.war ]]
  then
    rm $WKDIR/build-output/*.war
  fi

  if [[ -f $WKDIR/build-output/*.jar ]]
  then
    rm $WKDIR/build-output/*.jar
  fi
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

  echo "Test" > $BUILD_TXT
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

checkout_build_config() {
  cd $WKDIR
  SRCH=".[\"build-config\"].\"$BC_LABEL\".tags.\"$2\""
  branch=`python3 build-config.py|jq -r $SRCH`
  cd $WKDIR/$1
  git checkout origin/$branch >> $LOGGIT 2>&1
  echo "checkout dir: $1, repo: $2, branch: $branch" >> $LOGSUM
}

checkout_tag() {
  cd $WKDIR/$1
  tag=$2
  git checkout origin/$tag >> $LOGGIT 2>&1
  echo "checkout dir: $1, tag: $tag" >> $LOGSUM
}

scan_image() {
  if test_flag 'scan-fixable'
  then
    trivy --scanners vuln image --severity CRITICAL --exit-code 100 $1 >> $LOGSCAN 2>&1
    eval_jobstat $? "WARN" "Scan $1"
  else 
    echo "       Scan disabled" >> $LOGSUM
  fi

  if test_flag 'scan-unfixable'
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
  if test_flag 'push'
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

  if test_flag 'push'
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

test_flag() {
  if [[ "`get_flag $1`" == "true" ]]; then return 0; else return 1; fi
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

  checkout_build_config 'mrt-services/dep_core/mrt-core2' 'mrt-core'
  checkout_build_config 'mrt-services/dep_cloud/mrt-cloud' 'mrt-cloud'
  checkout_build_config 'mrt-services/dep_cdlzk/cdl-zk-queue' 'cdl-zk-queue'
  checkout_build_config 'mrt-services/dep_zoo/mrt-zoo' 'mrt-zoo'

  if [[ "$MAVEN_PROFILE" == "-P inventory" ]] && [[ "$CHECK_REPO_TAG" != "" ]]
  then
    checkout_tag 'mrt-services/inventory/mrt-inventory' $CHECK_REPO_TAG
  else
    checkout_build_config 'mrt-services/inventory/mrt-inventory' 'mrt-inventory'
  fi

  if [[ "$MAVEN_PROFILE" == "-P store" ]] && [[ "$CHECK_REPO_TAG" != "" ]]
  then
    checkout_tag 'mrt-services/store/mrt-store' $CHECK_REPO_TAG
  else
    checkout_build_config 'mrt-services/store/mrt-store' 'mrt-store'
  fi
  
  if [[ "$MAVEN_PROFILE" == "-P ingest" ]] && [[ "$CHECK_REPO_TAG" != "" ]]
  then
    checkout_tag 'mrt-services/ingest/mrt-ingest' $CHECK_REPO_TAG
  else
    checkout_build_config 'mrt-services/ingest/mrt-ingest' 'mrt-ingest'
  fi
  
  if [[ "$MAVEN_PROFILE" == "-P audit" ]] && [[ "$CHECK_REPO_TAG" != "" ]]
  then
    checkout_tag 'mrt-services/audit/mrt-audit' $CHECK_REPO_TAG
  else
    checkout_build_config 'mrt-services/audit/mrt-audit' 'mrt-audit'
  fi
  
  if [[ "$MAVEN_PROFILE" == "-P replic" ]] && [[ "$CHECK_REPO_TAG" != "" ]]
  then
    checkout_tag 'mrt-services/replic/mrt-replic' $CHECK_REPO_TAG
  else
    checkout_build_config 'mrt-services/replic/mrt-replic' 'mrt-replic'
  fi

  checkout_build_config 'mrt-services/ui/mrt-dashboard' 'mrt-dashboard'
  checkout_build_config 'mrt-integ-tests' 'mrt-integ-tests'
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

check_maven_profile() {
  if [[ "$MAVEN_PROFILE" == "-P $1" ]] || [[ "$MAVEN_PROFILE" == "-P uc3" ]] || [[ "$MAVEN_PROFILE" == "" ]]; then return 0; else return 1; fi
}

write_build_content() {
  if [[ "$MAVEN_PROFILE" == "-P uc3" ]] || [[ "$MAVEN_PROFILE" == "" ]]
  then
    echo "$TAG_PUB; $MD_BRANCH; $BC_LABEL; ${MAVEN_PROFILE}" > $BUILD_TXT
  elif [[ "$CHECK_REPO_TAG" != "" ]]
  then
    echo "$CHECK_REPO_TAG" > $BUILD_TXT
  else
    echo "$TAG_PUB; $MD_BRANCH; $BC_LABEL; ${MAVEN_PROFILE}" > $BUILD_TXT
  fi
}

build_maven_artifacts() {
  show_header "Run maven builds and integration tests" $LOGMAVEN

  cd $WKDIR/mrt-services

  write_build_content

  if test_flag 'run-maven' || test_flag 'run-maven-tests'
  then
    echo >> $LOGSUM
    date >> $LOGSUM

    mvn clean install -f dep_core/mrt-core2/pom.xml -Pparent >> $LOGMAVEN 2>&1
    if test_flag 'run-maven-tests'
    then
      mvn clean install $MAVEN_PROFILE >> $LOGMAVEN 2>&1
    else
      mvn clean install -Ddocker.skip -DskipITs -Dmaven.test.skip=true $MAVEN_PROFILE >> $LOGMAVEN 2>&1
    fi
    mstat=$?
    eval_jobstat $mstat "FAIL" "Maven Build"

    if (( "$mstat" == "0" ))
    then
      if check_maven_profile 'store'
      then
        cp $WKDIR/mrt-services/store/mrt-store/store-war/target/mrt-storewar-1.0-SNAPSHOT.war $WKDIR/build-output/mrt-store-${TAG_PUB}.war
        mkdir -p $WKDIR/build-output/mrt-store
        jar uf $WKDIR/build-output/mrt-store/mrt-store-${TAG_PUB}.war -C `dirname $BUILD_TXT` `basename $BUILD_TXT`
      fi

      if check_maven_profile 'replic'
      then
        cp $WKDIR/mrt-services/replic/mrt-replic/replication-war/target/mrt-replicationwar-1.0-SNAPSHOT.war $WKDIR/build-output/mrt-replic-${TAG_PUB}.war
        mkdir -p $WKDIR/build-output/mrt-replic
        jar uf $WKDIR/build-output/mrt-replic/mrt-replic-${TAG_PUB}.war -C `dirname $BUILD_TXT` `basename $BUILD_TXT`
      fi

      if check_maven_profile 'ingest'
      then
        cp $WKDIR/mrt-services/ingest/mrt-ingest/ingest-war/target/mrt-ingestwar-1.0-SNAPSHOT.war $WKDIR/build-output/mrt-ingest-${TAG_PUB}.war
        mkdir -p $WKDIR/build-output/mrt-ingest
        jar uf $WKDIR/build-output/mrt-ingest/mrt-ingest-${TAG_PUB}.war -C `dirname $BUILD_TXT` `basename $BUILD_TXT`
      fi

      if check_maven_profile 'audit'
      then
        cp $WKDIR/mrt-services/audit/mrt-audit/audit-war/target/mrt-auditwarpub-1.0-SNAPSHOT.war $WKDIR/build-output/mrt-audit-${TAG_PUB}.war
        mkdir -p $WKDIR/build-output/mrt-audit
        jar uf $WKDIR/build-output/mrt-audit/mrt-audit-${TAG_PUB}.war -C `dirname $BUILD_TXT` `basename $BUILD_TXT`
      fi

      if check_maven_profile 'inventory'
      then
        cp $WKDIR/mrt-services/inventory/mrt-inventory/inv-war/target/mrt-invwar-1.0-SNAPSHOT.war $WKDIR/build-output/mrt-inventory-${TAG_PUB}.war
        mkdir -p $WKDIR/build-output/mrt-inventory
        jar uf $WKDIR/build-output/mrt-inventory/mrt-inventory-${TAG_PUB}.war -C `dirname $BUILD_TXT` `basename $BUILD_TXT`
      fi
    fi
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
  SUBJ="${STATUS}: Merritt Daily Build $MD_BRANCH - $BC_LABEL - ${MAVEN_PROFILE}"
  if [ "$JENKINS_HOME" == "" ]
  then
    cat $LOGSUM | mail -a $LOGSCAN -a $LOGSCANFIXED -s "$SUBJ" ${DIST//,/}
  fi
  echo $SUBJ
}

usage() {
  echo "fresh_build.sh "
  echo "  -h; display usage message"
  echo "  -B merritt-docker-branch to check out; defaut: main"
  echo "  -C build-config-profile-name entry, see build-config.yml for options; default: main"
  echo "  -m maven-profile to use for maven builts, options: uc3, ingest, inventory, store, audit, replic; default: uc3"
  echo "  -p tag-name-for-published-artifacts, part of generated war files; default: testall"
  echo "  -t checkout-repo, branch or tag to checkout when buiding a specific maven profiile, detault: main"
  echo "  -w workidir, working directory in which build will run"
  echo "    default: /apps/dpr2/merritt-workspace/daily-builds/[merritt-docker-branch].[build-config-profile-name]/merritt-docker"
  echo "      if path contains 'merritt-workspace/daily-builds', the directory will be recreated"
  echo "  -j workidir, Jenkins working directory in which build will run.  Jenkins will not create a 'merritt-docker' directory for clone"
  echo ""
}

show_options() {
  echo MD_BRANCH=$MD_BRANCH
  echo BC_LABEL=$BC_LABEL
  echo MAVEN_PROFILE=$MAVEN_PROFILE
  echo TAG_PUB=$TAG_PUB
  echo CHECK_REPO_TAG=$CHECK_REPO_TAG
  echo WKDIR=$WKDIR
  echo
}

# interpret flag options listed in the build-config.yml file
show_flags() {
  echo >> $LOGSUM
  echo "FLAG_PUSH=`get_flag push`" >> $LOGSUM
  echo "FLAG_SCAN=`get_flag scan-fixable`" >> $LOGSUM
  echo "FLAG_SCAN_UNFIXED=`get_flag scan-unfixable`" >> $LOGSUM
  echo "FLAG_RUN_MAVEN=`get_flag run-maven`" >> $LOGSUM
  echo "FLAG_RUN_MAVEN_TESTS=`get_flag run-maven-tests`" >> $LOGSUM
  echo "FLAG_BUILD_SUPPORT=`get_flag build-support`" >> $LOGSUM
}


MD_BRANCH=main
BC_LABEL=main
MAVEN_PROFILE="-P uc3"
TAG_PUB=testall
CHECK_REPO_TAG=
HELP=0

while getopts "B:C:m:p:t:w:j:h" flag 
do
    case "${flag}" in
        B) MD_BRANCH=${OPTARG};;
        C) BC_LABEL=${OPTARG};;
        m) MAVEN_PROFILE="-P ${OPTARG}";;
        p) TAG_PUB=${OPTARG};;
        t) CHECK_REPO_TAG=${OPTARG}
           TAG_PUB=$CHECK_REPO_TAG
           ;;
        w) WKDIR=${OPTARG}
           WKDIR_PAR=`dirname $WKDIR`
           ;;
        # Jenkins checks contents out into a clone directory without creating a merritt-docker folder
        j) WKDIR=${OPTARG}
           WKDIR_PAR=$WKDIR
           ;;
        h) usage
           exit
           ;;
    esac
done

# Compute working directory if it is not set
if [[ "$WKDIR" == "" ]]
then
  WKDIR_PAR=/apps/dpr2/merritt-workspace/daily-builds/${MD_BRANCH}.${BC_LABEL}
  WKDIR=/apps/dpr2/merritt-workspace/daily-builds/${MD_BRANCH}.${BC_LABEL}/merritt-docker
fi

show_options

# If the working directory contains "merritt-workspace/daily-builds", delete and recreate the directory
create_working_dir

# Create output files for the build steps
BUILD_TXT=${WKDIR}/build.content.txt
LOGSUM=${WKDIR}/build-output/build-log.summary.txt
LOGGIT=${WKDIR}/build-output/build-log.git.txt
LOGDOCKER=${WKDIR}/build-output/build-log.docker.txt
LOGSCAN=${WKDIR}/build-output/build-log.trivy-scan.txt
LOGSCANFIXED=${WKDIR}/build-output/build-log.trivy-scan-fixed.txt
LOGMAVEN=${WKDIR}/build-output/build-log.maven.txt
JOBSTAT=${WKDIR}/build-output/jobstat.txt

init_log_files

# If running on a UC3 DEV server, initialize the environment
# On the Jenkins server, this will wipe out settings that have already be configured
if [ "$JENKINS_HOME" == "" ]
then
  environment_init
fi

# Clone merriit-docker if needed
# Expand submodules if needed
if is_daily_build_dir 
then
  git_repo_init
  git_repo_submodules
elif [ "$JENKINS_HOME" != "" ]
then
  sed -i -e "s/git@github.com:/https:\/\/github.com\//" .git/config
  git_repo_submodules
fi

show_flags

# Build integration test docker images (these are needeed for maven integration tests)
build_integration_test_images
# Build artifacts with maven
build_maven_artifacts
# Build Merritt microservice docker images for docker testing
build_microservice_images
# Build supporting docker images for docker testing
build_docker_stack_support_images

# Build all other docker iamges used by Merritt (for daily scanning)
if test_flag 'build-support'
then
  build_merritt_lambda_images
  build_merritt_end_to_end_test_images
  scan_default_docker_stack_support_images
fi

post_summary_report
