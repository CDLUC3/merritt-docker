#! /bin/bash
source ./ecs-helpers.sh

export label="Stack Monitoring Checks"
export statfile="/tmp/stack-monitoring-log.txt"

monitor_url() {
  url=$1
  connect_timeout=${2:-2}
  max_time=${3:-5}

  status=$(curl -o /tmp/test.json -s -w "%{http_code}" --connect-timeout $connect_timeout --max-time $max_time "$url") || return
  echo "$url ==> $status"
  if [ "$status" -ne 200 ]; then
    echo "FAIL: $url ==> $status"
    return 1
  fi
}

monitor_services() {
  monitor_url "$(admintool_base)/context?admintoolformat=json"
  jq -e 'type == "object"' /tmp/test.json || echo "FAIL: admintool context not valid JSON object"

  monitor_url "$(ui_base)/state.json"
  jq -e 'type == "object"' /tmp/test.json || echo "FAIL: admintool context not valid JSON object"

  monitor_url "$(ingest_base)/state?t=json"
  jq -e '.["ing:ingestServiceState"].["ing:submissionState"] == "thawed"' /tmp/test.json || echo "FAIL: ingest submissionState not thawed"

  monitor_url "$(store_base)/state?t=json"
  jq -e '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' /tmp/test.json || echo "FAIL: storageServiceState failNodesCnt not 0"

  monitor_url "$(inventory_base)/state?t=json"
  jq -e '.["invsv:invServiceState"].["invsv:systemStatus"] == "running"' /tmp/test.json || echo "FAIL: inventory systemStatus not running"
  jq -e '.["invsv:invServiceState"].["invsv:zookeeperStatus"] == "running"' /tmp/test.json || echo "FAIL: inventory zookeeperStatus not running"

  monitor_url "$(audit_base)/state?t=json"
  jq -e '.["fix:fixityServiceState"].["fix:status"] == "running"' /tmp/test.json || echo "FAIL: fixity status not running"

  monitor_url "$(replic_base)/state?t=json"
  jq -e '.["repsvc:replicationServiceState"].["repsvc:status"] == "running"' /tmp/test.json || echo "FAIL: replication status not running"
}

task_init

monitor_services 2>&1 | tee -a $statfile

egrep -q "FAIL" $statfile && task_fail

task_complete