#! /bin/bash

source ./ecs-helpers.sh

export label="Downtime End"
export statfile="/tmp/downtime-end.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

unpause_ingest || task_fail
escalope_remove_block "ingest" "run-downtime-start.sh"
all_service_ips audit service/start?t=json
escalope_remove_block "audit" "run-downtime-start.sh"

task_complete