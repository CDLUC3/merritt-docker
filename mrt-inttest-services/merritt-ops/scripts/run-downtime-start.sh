#! /bin/bash

source ./ecs-helpers.sh

export label="Downtime Start"
export statfile="/tmp/downtime-start.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

escalope_add_block "ingest" 70 "run-downtime-start.sh" "weekly downtime beginning"
pause_ingest || task_fail
escalope_add_block "audit" 70 "run-downtime-start.sh" "weekly downtime beginning"
all_service_ips audit service/stop?t=json

task_complete