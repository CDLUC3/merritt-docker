#! /bin/bash

source ./ecs-helpers.sh

export label="Downtime End"
export statfile="/tmp/downtime-end.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

unpause_ingest || task_fail
escalope_update_block "ingest" "run-downtime-start.sh" alarm_resolve_min
all_service_ips audit service/start?t=json
escalope_update_block "audit" "run-downtime-start.sh" alarm_resolve_min

task_complete