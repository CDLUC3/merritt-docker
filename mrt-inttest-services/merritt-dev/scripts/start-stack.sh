#! /bin/bash

source ./ecs-helpers.sh

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  echo "Starting AUX services"
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo1         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo2         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo3         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ezid         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service smtp         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services ldap smtp ezid zoo1 zoo2 zoo3

  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ingest       --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service inventory    --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service audit        --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service replic       --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service store        --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --force-new-deployment --desired-count 2 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool ingest inventory audit replic store ui

  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null

  zk_restore
  stack_init
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  echo "Starting AUX services"
  aws ecs update-service --cluster $ECS_STACK_NAME --service zoo          --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service db-container --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service minio        --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ezid         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service smtp         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services ldap smtp ezid zoo minio db-container

  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ingest       --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service inventory    --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service audit        --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service replic       --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service store        --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --force-new-deployment --desired-count 2 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool ingest inventory audit replic store ui

  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null

  zk_restore
  stack_init
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap         --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services ldap

  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool ui merrittdev

  stack_init
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool merrittdev
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output yaml --no-cli-pager > /dev/null
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output yaml --no-cli-pager > /dev/null
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool merrittdev
fi