#! /bin/bash

source ./ecs-helpers.sh

export label="Downtime End"
export statfile="/tmp/downtime-end.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

unpause_ingest || task_fail
all_service_ips audit service/start?t=json

task_complete