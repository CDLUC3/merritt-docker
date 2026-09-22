#! /bin/bash

source ./ecs-helpers.sh

export label="Downtime Start"
export statfile="/tmp/downtime-start.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

pause_ingest || task_fail
all_service_ips audit service/stop?t=json

task_complete