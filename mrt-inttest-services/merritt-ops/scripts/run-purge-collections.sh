#! /bin/bash

source ./ecs-helpers.sh

export label="Purge Collections"
export statfile="/tmp/purge-collections-log.txt"

task_init

run_purge() {
  coll=$1
  echo "Purging $coll" 
  echo ""

  curl -X POST -H "Accept: application/json" -o /tmp/curl.json -s" $(admintool_base)/test/purge/${coll} || return
  jq '.[]' /tmp/curl.json
  count=$(jq -r '.|length' /tmp/curl.json)
  if [ $count -gt 0 ]
  then
    run_purge $coll
  fi
}

if [[ "$MERRITT_ECS" != "ecs-prd" ]]
then
  for coll in merritt_demo merritt_benchmark cdl_wasabi
  do
    run_purge $coll >> $statfile
  done
end

task_complete