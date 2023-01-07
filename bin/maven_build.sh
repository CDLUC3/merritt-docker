#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR=${START_DIR}/$SCRIPT_HOME/../mrt-services

export ECR_REGISTRY=it-docker-registry

cd $REPOS_DIR
mvn clena install
