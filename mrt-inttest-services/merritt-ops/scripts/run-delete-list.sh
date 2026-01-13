#! /bin/bash

source ./ecs-helpers.sh

export label="Run Delete List"
export statfile="/tmp/run-delete-list-log.txt"
filepath=$1

get_delete_lists() {
  curl -H "Accept: application/json" -s "$(admintool_base)/ops/inventory/list-delete-lists" | jq -r '.[]'
}

run_delete_list() {
  fname=$1
  echo "Purging $fname" 
  echo ""

  list=$(curl -H "Accept: application/json" -s "$(admintool_base)/ops/inventory/delete-list/${fname}" | jq -r '.[]')
  for ark in $list 
  do
    echo "$ark"
    url="$(admintool_base)/ops/inventory/delete?ark=$(printf '%s' $ark | jq -sRr @uri)"
    echo $url
    curl -X POST -H "Accept: application/json" -s "$url" || return
    echo
  done
  echo
  echo
}

if [[ "$filepath" == "" ]]
then
  echo "Please provide a delete list filename..."
  echo
  get_delete_lists
else
  task_init
  run_delete_list $filepath 2>&1 | tee $statfile
  task_complete
fi

