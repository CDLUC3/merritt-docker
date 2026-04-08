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

# Check a service with a jq validation query
# Usage: check_service_json <name> <url> <jq_query> <error_message>
check_service_json() {
  local service=$1
  local host=$2
  local endpoint=$3
  local hosts=$4

  local healthycount=1

  for hh in $(echo $hosts | tr ',' '\n')
  do
    local url="$hh/$endpoint"
    if ! monitor_url_json "$url"
    then
      echo "Host failure for $url"
      healthycount=0
    fi
  done

  local url="$host/$endpoint"

  if ! monitor_url_json "$url"
  then
    healthycount=0
  else
    if ! jq -e 'type == "object"' /tmp/test.json >/dev/null
    then
      healthycount=0
    fi
  fi

  aws cloudwatch put-metric-data --region us-west-2 --namespace merritt \
    --dimensions "stack=$MERRITT_ECS,service=$service" \
    --unit Count --metric-name healthy-count --value $healthycount

  if [ $healthycount -eq 0 ]; then
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
  local healthycount=1

  if ! jq -e "$jq_query" /tmp/test.json >/dev/null 2>&1
  then
    state="CRITICAL"
    cause="$error_msg"
    healthycount=0
  fi

  aws cloudwatch put-metric-data --region us-west-2 --namespace merritt \
    --dimensions "stack=$MERRITT_ECS,service=$service" \
    --unit Count --metric-name "$error_msg" --value $healthycount

  if [ "$state" == "CRITICAL" ]; then
    return 1
  fi
  return 0
}

stack_metrics() {
  local url=$1
  local connect_timeout=${2:-5}
  local max_time=${3:-60}

  echo "Metrics Check: $url"

  local status=$(curl -o /tmp/test.json -s -w "%{http_code}" \
    --connect-timeout "$connect_timeout" \
    --max-time "$max_time" \
    "$url") || return 1
  
  if [ "$status" -ne 200 ]
  then
    echo "Metrics Return Status: $status"
    return 1
  fi

  jq . /tmp/test.json
  cat /tmp/test.json | jq -r 'keys[]' | while IFS= read -r key; do
    val=$(jq -e ".$key" /tmp/test.json)

    if [[ "$key" =~ ^gb_ ]]
    then
      aws cloudwatch put-metric-data --region us-west-2 --namespace merritt \
        --dimensions "stack=$MERRITT_ECS" \
        --unit Gigabytes --metric-name "$key" --value "$val"
    else
      aws cloudwatch put-metric-data --region us-west-2 --namespace merritt \
        --dimensions "stack=$MERRITT_ECS" \
        --unit Count --metric-name "$key" --value "$val"
    fi
  done

  return 0
}

monitor_services() {
  # Admintool
  check_service_json "admintool" \
    "$(admintool_base)" "state" ""

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
    "$(ui_base)" "state.json" ""

  # Ingest
  check_service_json "ingest" \
    "$(ingest_base)" "state?t=json" "$HOSTS_INGEST"

  validation_check_json "ingest" \
    '.["ing:ingestServiceState"].["ing:submissionState"] == "thawed"' \
    "ingest submissionState not thawed" 

  # Store
  check_service_json "store" \
    "$(store_base)" "state?t=json" "$HOSTS_STORE"

  validation_check_json "store" \
    '.["sto:storageServiceState"].["sto:failNodesCnt"] == 0' \
    "store failNodesCnt not 0" 
  
  # Access
  check_service_json "access" \
    "$(access_base)" "state?t=json" "$HOSTS_ACCESS"
 
  # Inventory (multiple checks)
  check_service_json "inventory" \
    "$(inventory_base)" "state?t=json" "$HOSTS_INVENTORY"
  
  validation_check_json "inventory" \
    '.["invsv:invServiceState"].["invsv:systemStatus"] == "running"' \
    "inventory systemStatus not running"

  # Audit
  check_service_json "audit" \
    "$(audit_base)" "state?t=json" "$HOSTS_AUDIT"
  
  validation_check_json "audit" \
    '.["fix:fixityServiceState"].["fix:status"] == "running"' \
    "fixity status not running"

  # Replication (uses status instead of state)
  check_service_json "replic" \
    "$(replic_base)" "status?t=json" "$HOSTS_REPLIC"
  
  validation_check_json "replic" \
    '.["repsvc:replicationServiceState"].["repsvc:status"] == "running"' \
    "replication status not running" 30

  stack_metrics "$(admintool_base)/metrics"
}

task_init

monitor_services 2>&1 | tee -a "$statfile"

grep -q "CRITICAL" "$statfile" && task_fail

task_complete