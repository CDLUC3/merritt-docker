#! /bin/bash

source ./ecs-helpers.sh

echo " ==> redeployStack"

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services"
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ingest       --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service inventory    --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service audit        --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service replic       --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service store        --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --force-new-deployment --desired-count 2 --output text --no-cli-pager 
  sleep 30

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool ingest inventory audit replic store ui
  echo " ==> Service Wait Complete"

  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  echo " ==> Merritt Dev Deployment Complete"

  stack_init
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services"
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ingest       --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service inventory    --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service audit        --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service replic       --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service store        --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --force-new-deployment --desired-count 2 --output text --no-cli-pager 
  sleep 30

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool ingest inventory audit replic store ui
  echo " ==> Service Wait Complete"

  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  echo " ==> Merritt Dev Deployment Complete"
  
  stack_init
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services and Merritt Dev"
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service ui           --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  sleep 30

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool ui merrittdev
  echo " ==> Service Wait Complete"

  stack_init
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services and Merritt Dev"
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  sleep 30

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool merrittdev
  echo " ==> Service Wait Complete"
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services and Merritt Dev"
  aws ecs update-service --cluster $ECS_STACK_NAME --service admintool    --force-new-deployment --desired-count 2 --output text --no-cli-pager 
  aws ecs update-service --cluster $ECS_STACK_NAME --service merrittdev   --force-new-deployment --desired-count 1 --output text --no-cli-pager 
  sleep 30

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services admintool merrittdev
  echo " ==> Service Wait Complete"
fi

echo " ==> Complete"
