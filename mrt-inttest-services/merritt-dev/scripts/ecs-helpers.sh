#! /bin/bash

admintool_ip() {
  aws servicediscovery discover-instances \
    --service-name admintool --namespace-name merritt-${MERRITT_ECS} | \
    jq -r ".Instances[ $RANDOM % (.Instances | length)].Attributes.AWS_INSTANCE_IPV4"
}

admintool_base() {
  echo "http://$(admintool_ip):9292"
}


curl_format() {
  echo "Status: %{http_code}; Size: %{size_download}; Time: %{time_total}"
}

test_route() {
  route=$1
  status=$(curl -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" $(admintool_base)/${route})
  title=$(cat /tmp/curl.json | jq -r '.context.title // "na"' 2>/dev/null)
  rows=$(cat /tmp/curl.json | jq -r '(.table | length | tostring)' 2>/dev/null)
  result=$(cat /tmp/curl.json | jq -r '((.status // "NA") + ": " + .status_message)' 2>/dev/null)
  echo $route
  echo "  Result: $result; Rows: $rows; $status; Title: $title"
}


post_route() {
  route=$1
  status=$(curl -X POST -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" $(admintool_base)/${route})
  title=$(cat /tmp/curl.json | jq -r '.context.title // "na"' 2>/dev/null)
  rows=$(cat /tmp/curl.json | jq -r '(.table | length | tostring)' 2>/dev/null)
  result=$(cat /tmp/curl.json | jq -r '((.status // "NA") + ": " + .status_message)' 2>/dev/null)
  echo $route
  echo "  Result: $result; Rows: $rows; $status; Title: $title"
}

admintool_test_routes() {
  for route in $(curl --no-progress-meter "$(admintool_base)/test/routes" | jq -r '.[]')
  do
    test_route $route
  done
}

admintool_run_consistency_checks() {
  post_route '/queries/update-billing'
  for route in $(curl --no-progress-meter "$(admintool_base)/test/consistency" | jq -r '.[]')
  do
    test_route $route
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

task_init() {
  echo " ==> $label Started"
  date "+%Y-%m-%d %H:%M:%S: $label Started" > $statfile
}

task_complete() {
  echo " ==> $label Complete"
  date "+%Y-%m-%d %H:%M:%S: $label Complete" >> $statfile
  aws sns publish --topic-arn "$SNS_ARN" --subject "Merritt ECS $label for $MERRITT_ECS" --message "$(cat $statfile)"
}

task_fail() {
  echo " ==> $label Failed"
  date "+%Y-%m-%d %H:%M:%S: $label Failed" >> $statfile
  aws sns publish --topic-arn "$SNS_ARN" --subject "FAIL: Merritt ECS $label for $MERRITT_ECS" --message "$(cat $statfile)"
}