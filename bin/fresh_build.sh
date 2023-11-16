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
}

get_jobstat(){ 
  if [ -e $JOBSTAT ]
  then
    cat $JOBSTAT
  fi
}

# jobstat(status)
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

check_jobstat() {
  STATUS=`get_jobstat`
  if [ "$1" == "PASS" ]; then return 0; else return 1; fi
}

init_log_files() {
  rm -rf $WKDIR_PAR/build-output
  mkdir -p $WKDIR_PAR/build-output
  echo "See Log Ouput in $LOGSUM"

  echo "Working Dir: ${WKDIR}" > $LOGSUM
  echo " - ${LGOGIT}" >> $LOGGIT
  echo " - ${LOGDOCKER}" >> $LOGSUM
  echo " - ${LOGSUM}" >> $LOGSUM
  echo " - ${LOGSCAN}" >> $LOGSUM
  echo " - ${LOGSCANIGNORE}" >> $LOGSUM
  echo " - ${LOGSCANFIXED}" >> $LOGSUM
  echo " - ${LOGMAVEN}" >> $LOGSUM
  echo >> $LOGSUM

  echo "Test" > $BUILD_TXT
  echo > $LOGGIT
  echo > $LOGSCAN
  echo > $LOGDOCKER
  echo > $LOGMAVEN
  echo "Fixable items below.  See the attached report for the full vulnerability list: \n\n" > $LOGSCANFIXED
  echo "Items not included in .trivyignore: \n\n" > $LOGSCANIGNORE
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
  export PATH=$PATH:/usr/local/bin

  # source env vars
  if [[ "$AWS_ACCOUNT_ID" == "" ]]
  then
    echo "Setting up docker environment" >> $LOGSUM
    [ -f "$DOCKER_ENV_FILE" ] && . "$DOCKER_ENV_FILE" || echo "file $DOCKER_ENV_FILE not found" >> $LOGSUM
  fi
  source ~/.profile.d/uc3-aws-util.sh
  export PATH=/opt/maven/apache-maven-3.8.4/bin:/usr/lib/jvm/java-11-openjdk/bin:$PATH

  echo "Setup ECS login" >> $LOGSUM
  aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REGISTRY}
}

checkout_build_config() {
  cd $WKDIR
  SRCH=".[\"build-config\"].\"$BC_LABEL\".tags.\"$2\""
  branch=`python3 build-config.py|jq -r $SRCH`
  cd $WKDIR/$1
  git checkout origin/$branch >> $LOGGIT 2>&1
  eval_jobstat $? "FAIL" "checkout dir: $1, repo: $2, branch: $branch"
}

checkout_tag() {
  cd $WKDIR/$1
  tag=$2
  if git show-ref --quiet refs/tags/$tag
  then
    git checkout refs/tags/$tag >> $LOGGIT 2>&1
    eval_jobstat $? "FAIL" "checkout dir: $1, tag: $tag"
  else
    git checkout origin/$tag >> $LOGGIT 2>&1
    eval_jobstat $? "FAIL" "checkout dir: $1, branch: $tag"
  fi
}

scan_image() {
  if test_flag 'scan-fixable'
  then
    trivy --ignorefile /dev/null --scanners vuln image --severity CRITICAL $1 >> $LOGSCAN 2>&1
    trivy --ignorefile $WKDIR/.trivyignore --scanners vuln image --severity CRITICAL --exit-code 100 $1 >> $LOGSCANIGNORE 2>&1
    eval_jobstat $? "WARN" "Scan $1"
  else 
    echo "       Scan disabled" >> $LOGSUM
  fi

  if test_flag 'scan-unfixable'
  then
    trivy --ignorefile $WKDIR/.trivyignore --scanners vuln image --severity CRITICAL  --exit-code 150 --ignore-unfixed $1 >> $LOGSCANFIXED 2>&1
    eval_jobstat $? "FAIL" "Scan (ignore unfixed) $1"
  else 
    echo "       Scan unfixed disabled" >> $LOGSUM
  fi
}

build_image() {
  sleep 2
  echo >> $LOGSUM
  date >> $LOGSUM
  docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} --no-cache --force-rm $3 -t $1 $2 >> $LOGDOCKER 2>&1 
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

  docker-compose -f $1 build --no-cache >> $LOGDOCKER 2>&1
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
  git clone https://github.com/CDLUC3/merritt-docker.git >> $LOGGIT 2>&1
  eval_jobstat $? "FAIL" "Git clone merritt-docker branch"
  cd $WKDIR
  git checkout $MD_BRANCH >> $LOGGIT 2>&1
  eval_jobstat $? "FAIL" "Git checkout merritt-docker branch"
}

git_repo_submodules() {
  git submodule update --remote --init >> $LOGGIT 2>&1
  eval_jobstat $? "FAIL" "Git submodule update"
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
  build_it_image merritt-tomcat/docker-compose.yml ${ECR_REGISTRY}/merritt-tomcat:dev
  build_it_image merritt-maven/docker-compose.yml ${ECR_REGISTRY}/merritt-maven:dev
}

check_maven_profile() {
  if [[ "$MAVEN_PROFILE" == "-P $1" ]] || [[ "$MAVEN_PROFILE" == "-P uc3" ]] || [[ "$MAVEN_PROFILE" == "" ]]; then return 0; else return 1; fi
}

write_build_content() {
  if [[ "$MAVEN_PROFILE" == "-P uc3" ]] || [[ "$MAVEN_PROFILE" == "" ]]
  then
    echo "Building tag $TAG_PUB; $MD_BRANCH; $BC_LABEL; ${MAVEN_PROFILE}" > $BUILD_TXT
  elif [[ "$CHECK_REPO_TAG" != "" ]]
  then
    echo "Building tag $CHECK_REPO_TAG" > $BUILD_TXT
  else
    echo "Building tag $TAG_PUB; $MD_BRANCH; $BC_LABEL; ${MAVEN_PROFILE}" > $BUILD_TXT
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

    mvn --version >> $LOGMAVEN 2>&1
    mvn -ntp clean install -f dep_core/mrt-core2/pom.xml -Pparent >> $LOGMAVEN 2>&1
    if test_flag 'run-maven-tests'
    then
      mvn -ntp clean install $MAVEN_PROFILE >> $LOGMAVEN 2>&1
    else
      mvn -ntp clean install -Ddocker.skip -DskipITs -Dmaven.test.skip=true $MAVEN_PROFILE >> $LOGMAVEN 2>&1
    fi
    mstat=$?
    eval_jobstat $mstat "FAIL" "Maven Build"

    if (( "$mstat" == "0" ))
    then
      if check_maven_profile 'store'
      then
        mkdir -p $ARTIFACTS/mrt-store
        cp $WKDIR/mrt-services/store/mrt-store/store-war/target/mrt-storewar-1.0-SNAPSHOT.war $ARTIFACTS/mrt-store/mrt-store-${TAG_PUB}.war
        jar uf $ARTIFACTS/mrt-store/mrt-store-${TAG_PUB}.war -C ${WKDIR_PAR} ${BUILD_TXT_FILE}
      fi

      if check_maven_profile 'replic'
      then
        mkdir -p $ARTIFACTS/mrt-replic
        cp $WKDIR/mrt-services/replic/mrt-replic/replication-war/target/mrt-replicationwar-1.0-SNAPSHOT.war $ARTIFACTS/mrt-replic/mrt-replic-${TAG_PUB}.war
        jar uf $ARTIFACTS/mrt-replic/mrt-replic-${TAG_PUB}.war -C ${WKDIR_PAR} ${BUILD_TXT_FILE}
      fi

      if check_maven_profile 'ingest'
      then
        mkdir -p $ARTIFACTS/mrt-ingest
        cp $WKDIR/mrt-services/ingest/mrt-ingest/ingest-war/target/mrt-ingestwar-1.0-SNAPSHOT.war $ARTIFACTS/mrt-ingest/mrt-ingest-${TAG_PUB}.war
        jar uf $ARTIFACTS/mrt-ingest/mrt-ingest-${TAG_PUB}.war -C ${WKDIR_PAR} ${BUILD_TXT_FILE}
      fi

      if check_maven_profile 'audit'
      then
        mkdir -p $ARTIFACTS/mrt-audit
        cp $WKDIR/mrt-services/audit/mrt-audit/audit-war/target/mrt-auditwarpub-1.0-SNAPSHOT.war $ARTIFACTS/mrt-audit/mrt-audit-${TAG_PUB}.war
        jar uf $ARTIFACTS/mrt-audit/mrt-audit-${TAG_PUB}.war -C ${WKDIR_PAR} ${BUILD_TXT_FILE}
      fi

      if check_maven_profile 'inventory'
      then
        mkdir -p $ARTIFACTS/mrt-inventory
        cp $WKDIR/mrt-services/inventory/mrt-inventory/inv-war/target/mrt-invwar-1.0-SNAPSHOT.war $ARTIFACTS/mrt-inventory/mrt-inventory-${TAG_PUB}.war
        jar uf $ARTIFACTS/mrt-inventory/mrt-inventory-${TAG_PUB}.war -C ${WKDIR_PAR} ${BUILD_TXT_FILE}
      fi
    fi
  else 
    echo "       Maven build disabled" >> $LOGSUM
  fi
}

build_microservice_images() {
  show_header "Build Merritt Images" $LOGDOCKER

  cd $WKDIR/mrt-services

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
}

build_merritt_lambda_images() {
  show_header "Build Merritt Lambda Images" $LOGDOCKER

  cd $WKDIR/mrt-services

  build_image_push ${ECR_REGISTRY}/mysql-ruby-lambda mrt-admin-lambda/mysql-ruby-lambda
  build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-common:dev mrt-admin-lambda/src-common
  build_image_push ${ECR_REGISTRY}/uc3-mrt-admin-lambda:dev mrt-admin-lambda/src-admintool
  build_image_push ${ECR_REGISTRY}/uc3-mrt-colladmin-lambda:dev mrt-admin-lambda/src-colladmin
  build_image_push ${ECR_REGISTRY}/uc3-mrt-cognitousers:dev mrt-admin-lambda/cognito-lambda-nonvpc

  # This image facilitates dev testing of our lambda code without deploying to lambda
  # We rarely use this approach any longer, but the image code is being maintained in case that development workflow 
  # is needed in the future.
  build_image_push ${ECR_REGISTRY}/simulate-lambda-alb mrt-admin-lambda/simulate-lambda-alb
}

build_merritt_end_to_end_test_images() {
  show_header "Build Merritt End to End Test Images" $LOGDOCKER

  cd $WKDIR/mrt-integ-tests
  build_image_push ${ECR_REGISTRY}/mrt-integ-tests .
  build_image standalone-chrome-download-folder chrome-driver
}

scan_default_docker_stack_support_images() {
  echo >> $LOGSUM
  echo "Scan Supporting Docker Stack Images" >> $LOGSUM
  date >> $LOGSUM

  cd $WKDIR
  scan_image zookeeper
  scan_image ghusta/fakesmtp
  scan_image opensearchproject/opensearch
  scan_image opensearchproject/opensearch-dashboards
  scan_image opensearchproject/logstash-oss-with-opensearch-output-plugin
}

post_summary_report() {
  echo >> $LOGSUM
  date >> $LOGSUM
  STATUS=`get_jobstat`
  SUBJ="${STATUS}: Merritt Daily Build $MD_BRANCH - $BC_LABEL - ${MAVEN_PROFILE}"
  if [[ "$JENKINS_HOME" == "" ]] && [[ $EMAIL > 0 ]]
  then
    DIST=`get_ssm_value_by_name 'batch/email'`
    cat $LOGSUM | mail -a $LOGSCAN -a $LOGSCANIGNORE -a $LOGSCANFIXED -s "$SUBJ" ${DIST//,/}
  else
    cat $LOGSUM
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
  echo "  -e email build results"
  echo "  -D prune all docker images and volumes (recommended to run weekly)"
  echo ""
  echo "Build Config Options"
  python3 build-config.py|jq -r ".[\"build-config\"] | with_entries(.value |= .description)"
  echo ""
}

show_options() {
  echo MD_BRANCH=$MD_BRANCH
  echo BC_LABEL=$BC_LABEL
  echo MAVEN_PROFILE=$MAVEN_PROFILE
  echo TAG_PUB=$TAG_PUB
  echo CHECK_REPO_TAG=$CHECK_REPO_TAG
  echo WKDIR=$WKDIR
  echo JAVA_RELEASE=$JAVA_RELEASE
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
EMAIL=0
export JAVA_RELEASE=${JAVA_RELEASE:-8}

while getopts "B:C:m:p:t:w:j:heD" flag 
do
    case "${flag}" in
        B) MD_BRANCH=${OPTARG};;
        C) BC_LABEL=${OPTARG};;
        m) MAVEN_PROFILE="-P ${OPTARG}";;
        p) TAG_PUB=${OPTARG};;
        t) CHECK_REPO_TAG=${OPTARG}
           if [[ "$CHECK_REPO_TAG" != "" ]]
           then
             TAG_PUB=$CHECK_REPO_TAG
           fi
           ;;
        w) WKDIR=${OPTARG}
           WKDIR_PAR=`dirname $WKDIR`
           ;;
        # Jenkins checks contents out into a clone directory without creating a merritt-docker folder
        j) WKDIR=${OPTARG}
           WKDIR_PAR=$WKDIR
           ;;
        e) EMAIL=1;;
        D) docker system df
           docker image prune -a -f 
           docker volume prune -f
           docker system prune -f
           docker system df
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
mkdir -p ${WKDIR_PAR}/static ${WKDIR_PAR}/build-output/artifacts
BUILD_TXT_FILE=static/build.content.txt
BUILD_TXT=${WKDIR_PAR}/${BUILD_TXT_FILE}
LOGSUM=${WKDIR_PAR}/build-output/build-log.summary.txt
LOGGIT=${WKDIR_PAR}/build-output/build-log.git.txt
LOGDOCKER=${WKDIR_PAR}/build-output/build-log.docker.txt
LOGSCAN=${WKDIR_PAR}/build-output/build-log.trivy-scan.txt
LOGSCANIGNORE=${WKDIR_PAR}/build-output/build-log.trivy-scan-ignore.txt
LOGSCANFIXED=${WKDIR_PAR}/build-output/build-log.trivy-scan-fixed.txt
LOGMAVEN=${WKDIR_PAR}/build-output/build-log.maven.txt
JOBSTAT=${WKDIR_PAR}/build-output/jobstat.txt
ARTIFACTS=${WKDIR_PAR}/build-output/artifacts

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
  sed -i -e "s/git@github.com:/https:\/\/github.com\//" .gitmodules
  sed -i -e "s/git@github.com:/https:\/\/github.com\//" .git/config
  git_repo_submodules
elif [ "$JENKINS_HOME" != "" ]
then
  sed -i -e "s/git@github.com:/https:\/\/github.com\//" .gitmodules
  sed -i -e "s/git@github.com:/https:\/\/github.com\//" .git/config
  git_repo_submodules
fi

if [[ ! check_jobstat ]]
then
  post_summary_report
  exit
fi

show_flags

# Build integration test docker images (these are needeed for maven integration tests)
if test_flag 'build-it'
then
  build_integration_test_images
fi

# Build artifacts with maven
build_maven_artifacts

# Build Merritt microservice docker images for docker testing
if test_flag 'build-stack'
then
  build_microservice_images
  # Build supporting docker images for docker testing
  build_docker_stack_support_images
fi

# Build all other docker iamges used by Merritt (for daily scanning)
if test_flag 'build-support'
then
  build_merritt_lambda_images
  build_merritt_end_to_end_test_images
  scan_default_docker_stack_support_images
fi

post_summary_report
