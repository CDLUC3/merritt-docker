#! /bin/bash

source ./ecs-helpers.sh

export label="Stop Merritt Opswrite"
export statfile="/tmp/stop-opswrite.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

aws ecs update-service --cluster $ECS_STACK_NAME --service merritt-opswrite --desired-count 0 \
  --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
  --output text --no-cli-pager || task_fail

task_complete