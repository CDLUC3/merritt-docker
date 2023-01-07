#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR=${START_DIR}/$SCRIPT_HOME/../mrt-services
echo "" > ${START_DIR}/dependencies.txt

echo "Analyzing mrt-core"
cd $REPOS_DIR
cd dep_core/mrt-core2
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing mrt-cloud"
cd $REPOS_DIR
cd dep_cloud/mrt-cloud
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing cdl-zk-queue"
cd $REPOS_DIR
cd dep_cdlzk/cdl-zk-queue
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing mrt-zoo"
cd $REPOS_DIR
cd dep_zoo/mrt-zoo
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing mrt-inventory"
cd $REPOS_DIR
cd inventory/mrt-inventory
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing mrt-replic"
cd $REPOS_DIR
cd replic/mrt-replic
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing mrt-audit"
cd $REPOS_DIR
cd audit/mrt-audit
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing mrt-store"
cd $REPOS_DIR
cd store/mrt-store
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo "Analyzing mrt-ingest"
cd $REPOS_DIR
cd ingest/mrt-ingest
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" >> ${START_DIR}/dependencies.txt

echo " ===> ${START_DIR}/dependencies.txt"