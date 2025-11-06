#! /bin/bash

source ./ecs-helpers.sh

export label="Stop Stack"
export statfile="/tmp/stop-log.txt"

task_init

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  echo " ==> Snapshot ZK"
  zk_snapshot
  sleep 30

  echo " ==> Stopping Merritt Dev"
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --desired-count 0 --output text --no-cli-pager 

  echo " ==> Stopping Merritt Services"
  # Per team discussion, always keep an admin instance running
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ingest       --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service inventory    --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service audit        --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service replic       --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service store        --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --desired-count 0 --output text --no-cli-pager 

  echo " ==> Stopping AUX Services"
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo1         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo2         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo3         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ezid         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service smtp         --desired-count 0 --output text --no-cli-pager 
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  echo " ==> Stopping Merritt Dev"
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --desired-count 0 --output text --no-cli-pager 

  echo " ==> Stopping Merritt Services"
  # Per team discussion, always keep an admin instance running
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ingest       --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service inventory    --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service audit        --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service replic       --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service store        --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --desired-count 0 --output text --no-cli-pager 

  echo " ==> Stopping AUX Services"
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo          --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service db-container --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service minio        --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ezid         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service smtp         --desired-count 0 --output text --no-cli-pager 
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Stopping All Services"
  # Per team discussion, always keep an admin instance running
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap         --desired-count 0 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --desired-count 0 --output text --no-cli-pager 
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Stopping All Services"
  # Per team discussion, always keep an admin instance running
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --desired-count 0 --output text --no-cli-pager 
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Stopping All Services"
  # Per team discussion, always keep an admin instance running
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --desired-count 0 --output text --no-cli-pager 
fi

task_complete