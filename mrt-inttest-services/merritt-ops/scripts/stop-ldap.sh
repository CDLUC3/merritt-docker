#! /bin/bash

source ./ecs-helpers.sh

export label="Redeploy LDAP"
export statfile="/tmp/redeploy-ldap.txt"

task_init

if [[ "$MERRITT_ECS" == "ecs-dev" || "$MERRITT_ECS" == "ecs-stg" || "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap --desired-count 0 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
    --output text --no-cli-pager || task_fail

  aws ecs update-service --cluster $ECS_STACK_NAME --service ldapreplica --desired-count 0 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
    --output text --no-cli-pager || task_fail
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap --desired-count 0 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
    --output text --no-cli-pager 
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo "No action"
fi

task_complete