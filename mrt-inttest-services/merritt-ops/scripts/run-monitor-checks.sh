#! /bin/bash
source ./ecs-helpers.sh

export label="Stack Monitoring Checks"
export statfile="/tmp/stack-monitoring-log.txt"

export escalope_token=$(aws ssm get-parameter --name /uc3/mrt/escalope_token --query Parameter.Value --output text --with-decryption)

# Fetch URL and save response to /tmp/test.json
# Returns 0 on success (HTTP 200), 1 otherwise
monitor_url_json() {
  local url=$1
  local connect_timeout=${2:-5}
  local max_time=${3:-20}

  local status=$(curl -o /tmp/test.json -s -w "%{http_code}" \
    --connect-timeout "$connect_timeout" \
    --max-time "$max_time" \
    "$url") || return 1
  
  if [ "$status" -ne 200 ]; then
    echo "Return Status: $status" > /tmp/status.code
    return 1
  fi
  return 0
}

# Send monitoring status as JSON
send_monitor_status() {
  local service=$1
  local state=${2:-OK}
  local cause=${3:-}

  local payload=$(jq -n \
    --arg host "ecs-uc3-mrt-$MERRITT_ECS-stack" \
    --arg service "$service" \
    --arg state "$state" \
    --arg cause "$cause" \
    '$ARGS.named')

  echo $payload

  curl -s -X POST -H "Content-Type: application/json" \
    "https://escalope.cdlib.org/notification_from_webcheck?CDLCognitoBypass=${escalope_token}" \
    -d "$payload" >/dev/null
}

# Check a service with a jq validation query
# Usage: check_service_json <name> <url> <jq_query> <error_message>
check_service_json() {
  local service=$1
  local url=$2

  local state='OK'
  local cause=''

  if ! monitor_url_json "$url"; then
    state="CRITICAL"
    cause="$(cat /tmp/status.code)"
  else
    if ! jq -e 'type == "object"' /tmp/test.json >/dev/null
    then
      state="CRITICAL"
      cause="Bad JSON returned"
    fi
  fi

  send_monitor_status "$service" "$state" "$cause"

  if [ "$state" == "CRITICAL" ]; then
    return 1
  fi
  return 0
}

validation_check_json() {
  local service=$1
  local jq_query=$2
  local error_msg=$3
  local suffix=${4:-}

  local label="appcheck-$service$suffix"
  local state='OK'
  local cause=''

  if ! jq -e "$jq_query" /tmp/test.json >/dev/null 2>&1
  then
    state="CRITICAL"
    cause="$error_msg"
  fi

  send_monitor_status "$label" "$state" "$cause"

  if [ "$state" == "CRITICAL" ]; then
    return 1
  fi
  return 0
}

monitor_services() {
  # Admintool
  check_service_json "admintool" \
    "$(admintool_base)/state"

  validation_check_json "admintool" \
    '.zk == "running"' \
    "Zookeeper not running" \
    "-zk"

  validation_check_json "admintool" \
    '.mysql == "running"' \
    "MySQL not running" \
    "-mysql"

  validation_check_json "admintool" \
    '.ldap == "running"' \
    "LDAP not running" \
    "-ldap"

  # UI
  check_service_json "ui" \
    "$(ui_base)/state.json"

  # Ingest
  check_service_json "ingest" \
    "$(ingest_base)/state?t=json"

  validation_check_json "ingest" \
    '.["ing:ingestServiceState"].["ing:submissionState"] == "thawed"' \
    "ingest submissionState not thawed" 

  # Store
  check_service_json "store" \
    "$(store_base)/state?t=json"

  validation_check_json "store" \
    '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' \
    "store failNodesCnt not 0" 
  
  # Access
  check_service_json "access" \
    "$(access_base)/state?t=json"
  
  validation_check_json "access" \
    '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' \
    "access failNodesCnt not 0" 

  # Inventory (multiple checks)
  check_service_json "inventory" \
    "$(inventory_base)/state?t=json"
  
  validation_check_json "inventory" \
    '.["invsv:invServiceState"].["invsv:systemStatus"] == "running"' \
    "inventory systemStatus not running"

  # Audit
  check_service_json "audit" \
    "$(audit_base)/state?t=json"
  
  validation_check_json "audit" \
    '.["fix:fixityServiceState"].["fix:status"] == "running"' \
    "fixity status not running"

  # Replication (uses status instead of state)
  check_service_json "replic" \
    "$(replic_base)/status?t=json"
  
  validation_check_json "replic" \
    '.["repsvc:replicationServiceState"].["repsvc:status"] == "running"' \
    "replication status not running"
}

task_init

monitor_services 2>&1 | tee -a "$statfile"

grep -q "CRITICAL" "$statfile" && task_fail

# task_complete