#! /bin/bash

admintool_ip() {
  aws servicediscovery discover-instances \
    --service-name admintool --namespace-name merritt-ecs-dev | \
    jq -r ".Instances[ $RANDOM % (.Instances | length)].Attributes.AWS_INSTANCE_IPV4"
}

admintool_base() {
  echo "http://$(admintool_ip):9292"
}


curl_format() {
  echo "\tStatus: %{http_code}\n\tContent-Type: %{content_type}\n\tSize: %{size_download}\n\tTime: %{time_total}\n"
}

test_route() {
  route=$1
  echo
  echo
  echo "$route"
  curl -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" $(admintool_base)/${route}
  cat /tmp/curl.json | jq -r '"\t\tTitle:\t" + .context.title // "na"' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\tRows:\t" + (.table | length | tostring)' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\t\t" + ((.status // "NA") + ":\t" + .status_message)' 2>/dev/null
}

post_route() {
  route=$1
  echo
  echo
  echo "$route"
  curl -X POST -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" $(admintool_base)/${route}
  cat /tmp/curl.json | jq -r '"\t\tTitle:\t" + .context.title // "na"' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\tRows:\t" + (.table | length | tostring)' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\t\t" + ((.status // "NA") + ":\t" + .status_message)' 2>/dev/null
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