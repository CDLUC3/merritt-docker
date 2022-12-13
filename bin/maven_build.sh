#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR=${START_DIR}/$SCRIPT_HOME/../mrt-services

export ECR_REGISTRY=it-docker-registry

echo "Building mock-core"
cd $REPOS_DIR
cd dep_core/mrt-core2
mvn clean install || exit 1

echo "Building mock-cloud"
cd $REPOS_DIR
cd dep_cloud/mrt-cloud
mvn clean install || exit 1

echo "Building cdl-zk-queue"
cd $REPOS_DIR
cd dep_cdlzk/cdl-zk-queue
mvn clean install || exit 1

echo "Building mrt-zoo"
cd $REPOS_DIR
cd dep_zoo/mrt-zoo
mvn clean install || exit 1

echo "Building mrt-inventory"
cd $REPOS_DIR
cd inventory/mrt-inventory
mvn clean install || exit 1

echo "Building mrt-replic"
cd $REPOS_DIR
cd replic/mrt-replic
mvn clean install || exit 1

echo "Building mrt-audit"
cd $REPOS_DIR
cd audit/mrt-audit
mvn clean install || exit 1

echo "Building mrt-store"
cd $REPOS_DIR
cd store/mrt-store
mvn clean install || exit 1

echo "Building mrt-ingest"
cd $REPOS_DIR
cd ingest/mrt-ingest
mvn clean install || exit 1
