#!/bin/bash
#set -x

run_diff() {
  name=$1
  dir=$2
  itdir=$3
  wardir=$4
  echo
  echo
  echo "  ** ${name} **"
  echo
  echo
  mvn -f ${dir}/${itdir} dependency:build-classpath|grep jar|sed -e "s/:/\n/g" | sort > it.txt
  mvn -f ${dir}/${wardir} dependency:build-classpath|grep jar|sed -e "s/:/\n/g" | sort > war.txt
  diff it.txt war.txt
}

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR=${START_DIR}/$SCRIPT_HOME/../mrt-services

cd $REPOS_DIR

run_diff "Inventory" "inventory/mrt-inventory" "inv-it"         "inv-war"
run_diff "Storage"   "store/mrt-store"         "store-it"       "store-war"
run_diff "Audit"     "audit/mrt-audit"         "audit-it"       "audit-war"
run_diff "Replic"    "replic/mrt-replic"       "replication-it" "replication-war"
run_diff "Ingest"    "ingest/mrt-ingest"       "ingest-it"      "ingest-war"
