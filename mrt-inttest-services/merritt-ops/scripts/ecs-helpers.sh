#! /bin/bash

service_ip() {
  service=$1
  aws servicediscovery discover-instances \
    --service-name $service --namespace-name merritt-${MERRITT_ECS} | \
    jq -r ".Instances[ $RANDOM % (.Instances | length)].Attributes.AWS_INSTANCE_IPV4"
}

admintool_ip() {
  service_ip admintool
}

admintool_base() {
  echo "http://$(admintool_ip):9292"
}

ingest_base() {
  host=$(service_ip ingest):8080/ingest
  echo ${SVC_INGEST:-$host}
}

store_base() {
  host=$(service_ip store):8080/store
  echo ${SVC_STORE:-$host}
}

acceess_base() {
  host=$(service_ip access):8080/access
  echo ${SVC_ACCESS:-$host}
}

audit_base() {
  host=$(service_ip audit):8080/audit
  echo ${SVC_AUDIT:-$host}
}

replic_base() {
  host=$(service_ip replic):8080/replic
  echo ${SVC_REPLIC:-$host}
}

inventory_base() {
  host=$(service_ip inventory):8080/inventory
  echo ${SVC_INVENTORY:-$host}
}

ui_base() {
  host=$(service_ip ui):8086
  echo ${SVC_UI:-$host}
}

curl_format() {
  echo "Status: %{http_code}; Size: %{size_download}; Time: %{time_total}"
}

test_route() {
  route=$1
  status=$(curl -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" $(admintool_base)/${route}) || return
  title=$(cat /tmp/curl.json | jq -r '.context.title // "na"' 2>/dev/null)
  rows=$(cat /tmp/curl.json | jq -r '(.table | length | tostring)' 2>/dev/null)
  result=$(cat /tmp/curl.json | jq -r '((.status // "NA") + ": " + .status_message)' 2>/dev/null)
  echo $route
  echo "  Result: $result; Rows: $rows; $status; Title: $title"

  # Extract numeric HTTP status code from curl -w output (e.g., "Status: 200; ...")
  code=$(echo "$status" | sed -nE 's/.*Status: ([0-9]{3}).*/\1/p')

  # Note that is it valid for a test to "FAIL"
  # On the other hand, "ERROR" indicates a software or enviornment bug
  if [ "${code:-0}" -ge 400 ] || [[ "$result" == "ERROR"* ]]
  then
    echo $route | tee -a $statfile
    echo "  Result: $result; Rows: $rows; $status; Title: $title" | tee -a $statfile
    return 1
  fi
}


post_route() {
  route=$1
  status=$(curl -X POST -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" $(admintool_base)${route}) || return
  title=$(cat /tmp/curl.json | jq -r '.context.title // "na"' 2>/dev/null)
  rows=$(cat /tmp/curl.json | jq -r '(.table | length | tostring)' 2>/dev/null)
  result=$(cat /tmp/curl.json | jq -r '((.status // "NA") + ": " + .status_message)' 2>/dev/null)

  echo $route
  echo "  Result: $result; Rows: $rows; $status; Title: $title"

  # Extract numeric HTTP status code from curl -w output (e.g., "Status: 200; ...")
  code=$(echo "$status" | sed -nE 's/.*Status: ([0-9]{3}).*/\1/p')

  if [ "${code:-0}" -ge 400 ] || [[ "$result" == "ERROR"* ]]
  then
    echo $route | tee -a $statfile
    echo "  Result: $result; Rows: $rows; $status; Title: $title" | tee -a $statfile
    return 1
  fi
}

admintool_test_routes() {
  stat=0
  for route in $(curl --no-progress-meter "$(admintool_base)/test/routes" | jq -r '.[]')
  do
    test_route $route || stat=1
  done
  return $stat
}

admintool_run_consistency_checks() {
  post_route '/queries/update-billing' || return 1
  for route in $(curl --no-progress-meter "$(admintool_base)/test/consistency" | jq -r '.[]')
  do
    test_route $route || return
  done
}

zk_snapshot() {
  echo "POST $(admintool_base)/ops/zk/snapshot... then wait 30 sec"
  curl --no-progress-meter -X POST $(admintool_base)/ops/zk/snapshot
}

zk_restore() {
  echo "POST $(admintool_base)/ops/zk/restore"
  curl --no-progress-meter -X POST $(admintool_base)/ops/zk/restore
}

stack_init() {
  echo "POST $(admintool_base)/stack-init"
  curl --no-progress-meter -X POST $(admintool_base)/stack-init
}

make_status() {
  datetime=$(TZ="America/Los_Angeles" date "+%Y-%m-%d %H:%M:%S")
  status=$1
  duration=$2

  echo $(jq -n \
    --arg task_datetime "$datetime" \
    --arg task_environment "$MERRITT_ECS" \
    --arg task_status "$status" \
    --arg task_label "$label" \
    --arg task_duration "${duration}" \
    '$ARGS.named')
}

task_init() {
  TZ="America/Los_Angeles" date "+ ==> %Y-%m-%d %H:%M:%S: START: $label for $MERRITT_ECS" | tee $statfile
  echo $(make_status "STARTED" "")
  export STARTTIME=$(date +%s)
}

task_complete() {
  TZ="America/Los_Angeles" date "+ ==> %Y-%m-%d %H:%M:%S: COMPLETE: $label for $MERRITT_ECS $(duration)" | tee -a $statfile
  echo $(make_status "COMPLETE" "$(duration)")
  subject="Merritt ECS $label for $MERRITT_ECS $(duration)"
  aws sns publish --topic-arn "$SNS_ARN" --subject "$subject" \
    --message "$(cat $statfile)"
}

task_fail() {
  TZ="America/Los_Angeles" date "+ ==> %Y-%m-%d %H:%M:%S: FAIL: $label for $MERRITT_ECS $(duration)" | tee -a $statfile
  echo $(make_status "FAIL" "$(duration)")
  subject="FAIL: Merritt ECS $label for $MERRITT_ECS $(duration)"
  aws sns publish --topic-arn "$SNS_ARN" --subject "$subject" \
    --message "$(cat $statfile)"
  exit 1
}

duration() {
  duration=$(( $(date +%s) - $STARTTIME ))
  min=$(( $duration / 60 ))
  sec=$(( $duration % 60 ))
  # Pad seconds with a leading zero when < 10
  if [ "$sec" -lt 10 ]; then sec="0$sec"; fi
  echo "($min:$sec sec)"
}
