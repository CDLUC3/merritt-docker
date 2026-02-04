#! /bin/bash
source ./ecs-helpers.sh

export label="Stack Monitoring Checks"
export statfile="/tmp/stack-monitoring-log.txt"

# Fetch URL and save response to /tmp/test.json
# Returns 0 on success (HTTP 200), 1 otherwise
monitor_url() {
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
  local status=${2:-OK}
  local cause=${3:-}

  jq -n \
    --arg host "$MERRITT_ECS" \
    --arg service "$service" \
    --arg status "$status" \
    --arg cause "$cause" \
    '$ARGS.named'
}

# Check a service with a jq validation query
# Usage: check_service <name> <url> <jq_query> <error_message>
check_service() {
  local service=$1
  local url=$2
  local jq_query=$3
  local error_msg=$4

  if ! monitor_url "$url"; then
    send_monitor_status "$service" "CRITICAL" "$(cat /tmp/status.code)"
    return 1
  fi

  if ! jq -e "$jq_query" /tmp/test.json >/dev/null 2>&1; then
    send_monitor_status "$service" "CRITICAL" "$error_msg"
    return 1
  fi

  send_monitor_status "$service"
  return 0
}

monitor_services() {
  # Admintool
  check_service "admintool" \
    "$(admintool_base)/context?admintoolformat=json" \
    'type == "object"' \
    "admintool context not valid JSON object"

  # UI
  check_service "ui" \
    "$(ui_base)/state.json" \
    'type == "object"' \
    "ui state not valid JSON object"

  # Ingest
  check_service "ingest" \
    "$(ingest_base)/state?t=json" \
    '.["ing:ingestServiceState"].["ing:submissionState"] == "thawed"' \
    "ingest submissionState not thawed"

  # Store
  check_service "store" \
    "$(store_base)/state?t=json" \
    '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' \
    "store failNodesCnt not 0"

  # Access
  check_service "access" \
    "$(access_base)/state?t=json" \
    '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' \
    "access failNodesCnt not 0"

  # Inventory (multiple checks)
  check_service "inventory" \
    "$(inventory_base)/state?t=json" \
    '.["invsv:invServiceState"].["invsv:systemStatus"] == "running" and .["invsv:invServiceState"].["invsv:zookeeperStatus"] == "running"' \
    "inventory systemStatus or zookeeperStatus not running"

  # Audit
  check_service "audit" \
    "$(audit_base)/state?t=json" \
    '.["fix:fixityServiceState"].["fix:status"] == "running"' \
    "fixity status not running"

  # Replication (uses status instead of state)
  check_service "replic" \
    "$(replic_base)/status?t=json" \
    '.["repsvc:replicationServiceState"].["repsvc:status"] == "running"' \
    "replication status not running"
}

task_init

monitor_services 2>&1 | tee -a "$statfile"

grep -q "CRITICAL" "$statfile" && task_fail

task_complete