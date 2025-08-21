#! /bin/bash

source ./ecs-helpers.sh

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  zk_snapshot
  sleep 30

  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo1 --force-new-deployment --desired-count 1 --output yaml --no-cli-pager 
  sleep 15
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo1

  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo2 --force-new-deployment --desired-count 1 --output yaml --no-cli-pager 
  sleep 15
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo2

  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo3 --force-new-deployment --desired-count 1 --output yaml --no-cli-pager 
  sleep 15
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo3
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  zk_snapshot
  sleep 30

  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo --force-new-deployment --desired-count 1 --output yaml --no-cli-pager 
  sleep 15
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo

  zk_restore
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo "No action"
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo "No action - will cycle 1-3"
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo "No action - will cycle 1-5"
fi