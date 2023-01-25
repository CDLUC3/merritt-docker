#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR=${START_DIR}/$SCRIPT_HOME/../mrt-services

cd $REPOS_DIR
mvn clean dependency:analyze
mvn dependency:analyze-only | egrep "WARNING|INFO..Building" > ${START_DIR}/dependencies.txt

echo
echo " ===> See ${START_DIR}/dependencies.txt"
echo

echo "Report on any non-standard entries"
egrep ":compile|Used " ${START_DIR}/dependencies.txt