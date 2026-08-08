#! /bin/bash

source ./ecs-helpers.sh

export label="Purge Collections"
export statfile="/tmp/purge-collections-log.txt"

task_init

run_purge() {
  coll=$1
  days=$2
  echo "Purging $coll" 
  echo ""

  echo curl -X POST -H "Accept: application/json" -o /tmp/curl.json -s \
    "$(admintool_base)/test/purge/${coll}?days=${days}&count=50"

  curl -X POST -H "Accept: application/json" -o /tmp/curl.json -s \
    "$(admintool_base)/test/purge/${coll}?days=${days}&count=50" || return
  
  echo "Message (if applicable)"
  jq '.[].message' /tmp/curl.json
  count=$(jq -r '.|length' /tmp/curl.json)

  echo "Count: [$count]"

  if [[ "$count" != "" ]]
  then
    if [ $count -gt 0 ]
    then
      run_purge $coll $days
    fi
  fi
}

if [[ "$MERRITT_ECS" != "ecs-prd" ]]
then
  for coll in merritt_demo merritt_benchmark cdl_wasabi
  do
    run_purge $coll 3 | tee -a $statfile
  done

  for coll in ucr_lib_nuxeo ucm_lib_dsc ucm_lib_jaac_newsletters \
    ucm_lib_mcdaniel ucm_lib_acm ucm_lib_mclean ucm_lib_clark
  do
    run_purge $coll 0 | tee -a $statfile
  done
fi

task_complete