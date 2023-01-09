#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR=${START_DIR}/$SCRIPT_HOME/../mrt-services

echo "ECR_REGISTRY must be set"
echo "ECR_REGISTRY=${ECR_REGISTRY}"

cd $REPOS_DIR
mvn clean install
