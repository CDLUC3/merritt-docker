#! /bin/sh
source ./ecs-helpers.sh

curl --no-progress-meter "http://$(admintool_ip):9292/test/consistency" | jq