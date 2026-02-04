#! /bin/bash
source ./ecs-helpers.sh

export label="Stack Monitoring Checks"
export statfile="/tmp/stack-monitoring-log.txt"

monitor_url() {
  url=$1
  connect_timeout=${2:-5}
  max_time=${3:-20}

  status=$(curl -o /tmp/test.json -s -w "%{http_code}" --connect-timeout $connect_timeout --max-time $max_time "$url") || return
  if [ "$status" -ne 200 ]; then
    echo "Return Status: $status" > /tmp/status.code
    return 1
  fi
}

send_monitor_status() {
  service=$1
  status=${2:-OK}
  cause=${3:-}

  echo $(jq -n \
    --arg host "$MERRITT_ECS" \
    --arg service "$service" \
    --arg status "$status" \
    --arg cause "$cause" \
    '$ARGS.named')
}

monitor_services() {
  monitor_url "$(admintool_base)/context?admintoolformat=json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "admintool" "CRITICAL" "$(cat /tmp/status.code)"
  else
    jq -e 'type == "object"' /tmp/test.json
    if [[ $? -ne 0 ]]
    then
      send_monitor_status "admintool" "CRITICAL" "admintool context not valid JSON object"
    else
      send_monitor_status "admintool"
    fi
  fi

  monitor_url "$(ui_base)/state.json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "ui" "CRITICAL" "$(cat /tmp/status.code)"
  else 
    jq -e 'type == "object"' /tmp/test.json
    if [[ $? -ne 0 ]]
    then
      send_monitor_status "ui" "CRITICAL" "ui state not valid JSON object"
    else
      send_monitor_status "ui"
    fi
  fi

  monitor_url "$(ingest_base)/state?t=json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "ingest" "CRITICAL" "$(cat /tmp/status.code)"
  else 
    jq -e '.["ing:ingestServiceState"].["ing:submissionState"] == "thawed"' /tmp/test.json
    if [[ $? -ne 0 ]]
    then
      send_monitor_status "ingest" "CRITICAL" "ingest submissionState not thawed"
    else
      send_monitor_status "ingest"
    fi
  fi

  monitor_url "$(store_base)/state?t=json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "store" "CRITICAL" "$(cat /tmp/status.code)"
  else 
    jq -e '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' /tmp/test.json
    if [[ $? -ne 0 ]]
    then
      send_monitor_status "store" "CRITICAL" "store failNodesCnt not 0"
    else
      send_monitor_status "store"
    fi
  fi

  monitor_url "$(access_base)/state?t=json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "access" "CRITICAL" "$(cat /tmp/status.code)"
  else 
    jq -e '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' /tmp/test.json
    if [[ $? -ne 0 ]]
    then
      send_monitor_status "access" "CRITICAL" "access failNodesCnt not 0"
    else
      send_monitor_status "access"
    fi
  fi

  monitor_url "$(inventory_base)/state?t=json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "inventory" "CRITICAL" "$(cat /tmp/status.code)"
  else
    jq -e '.["invsv:invServiceState"].["invsv:systemStatus"] == "running"' /tmp/test.json
    test1=$?
    jq -e '.["invsv:invServiceState"].["invsv:zookeeperStatus"] == "running"' /tmp/test.json
    test2=$?

    if [[ $test1 -ne 0 ]]
    then
      send_monitor_status "inventory" "CRITICAL" "inventory systemStatus not running"
    elif [[ $test2 -ne 0 ]]
    then
      send_monitor_status "inventory" "CRITICAL" "inventory zookeeperStatus not running"
    else
      send_monitor_status "inventory"
    fi
  fi

  monitor_url "$(audit_base)/state?t=json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "audit" "CRITICAL" "$(cat /tmp/status.code)"
  else
    jq -e '.["fix:fixityServiceState"].["fix:status"] == "running"' /tmp/test.json
    if [[ $? -ne 0 ]]
    then
      send_monitor_status "audit" "CRITICAL" "fixity status not running"
    else
      send_monitor_status "audit"
    fi
  fi

  # Per David, replic uses status instead of state
  monitor_url "$(replic_base)/status?t=json"
  if [[ $? -ne 0 ]]
  then
    send_monitor_status "replic" "CRITICAL" "$(cat /tmp/status.code)"
  else
    jq -e '.["repsvc:replicationServiceState"].["repsvc:status"] == "running"' /tmp/test.json
    if [[ $? -ne 0 ]]
    then
      send_monitor_status "replic" "CRITICAL" "$(cat /tmp/status.code)"
    else
      send_monitor_status "replic"
    fi
  fi
}

task_init

monitor_services 2>&1 | tee -a $statfile

egrep -q "FAIL" $statfile && task_fail

task_complete