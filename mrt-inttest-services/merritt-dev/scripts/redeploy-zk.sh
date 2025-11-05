#! /bin/bash

source ./ecs-helpers.sh

label=Redeploy ZK
statfile="/tmp/redeploy-zk.txt"

task_init

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> ZK Snapshot (cluster data will persist through re-deploy)"
  zk_snapshot
  sleep 30

  echo " ==> Redeploying zoo1"
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo1 --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  sleep 30
  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo1

  echo " ==> Redeploying zoo2"
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo2 --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  sleep 30
  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo2

  echo " ==> Redeploying zoo3"
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo3 --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  sleep 30
  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo3
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> ZK Snapshot"
  zk_snapshot
  sleep 30

  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  sleep 30
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services zoo

  echo " ==> ZK Restore (needed since only one not is active)"
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

task_complete