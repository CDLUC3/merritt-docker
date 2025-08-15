#! /bin/bash

admintool_ip() {
  aws servicediscovery discover-instances \
    --service-name admintool --namespace-name merritt-ecs-dev | \
    jq -r ".Instances[0].Attributes.AWS_INSTANCE_IPV4"
  }

curl_format() {
  echo "\tStatus: %{http_code}\n\tContent-Type: %{content_type}\n\tSize: %{size_download}\n\tTime: %{time_total}\n"
}

test_route() {
  route=$1
  echo
  echo
  echo "$route"
  curl -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" ${admintool}${route}
  cat /tmp/curl.json | jq -r '"\t\tTitle:\t" + .context.title // "na"' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\tRows:\t" + (.table | length | tostring)' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\t\t" + ((.status // "NA") + ":\t" + .status_message)' 2>/dev/null
}

post_route() {
  route=$1
  echo
  echo
  echo "$route"
  curl -X POST -H "Accept: application/json" -o /tmp/curl.json -s -w "$(curl_format)" ${admintool}${route}
  cat /tmp/curl.json | jq -r '"\t\tTitle:\t" + .context.title // "na"' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\tRows:\t" + (.table | length | tostring)' 2>/dev/null
  cat /tmp/curl.json | jq -r '"\t\t\t" + ((.status // "NA") + ":\t" + .status_message)' 2>/dev/null
}