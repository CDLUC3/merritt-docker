#! /bin/bash

source ./ecs-helpers.sh

export label="Redeploy Stack"
export statfile="/tmp/redeploy-log.txt"
export SLACK_ONSUCCESS=Y

task_init

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploy LDAP"
  /redeploy-ldap.sh || task_fail

  echo " ==> Redeploying Merritt Services"
  service_redeploy admintool || task_fail
  service_redeploy inventory || task_fail
  service_redeploy audit || task_fail
  service_redeploy replic || task_fail
  service_redeploy access || task_fail
  service_redeploy ui || task_fail
  sleep 75

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services admintool audit replic access ui || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Pause Ingest and Redeploy Services"
  pause_ingest || task_fail
  service_redeploy ingest || task_fail
  service_redeploy inventory || task_fail
  service_redeploy store || task_fail

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services ingest inventory store || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Unpause Ingest"
  unpause_ingest || task_fail

  service_redeploy merritt-ops || task_fail
  echo " ==> Merritt Ops Deployment Complete"

  stack_init
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services"
  service_redeploy admintool || task_fail
  service_redeploy ingest || task_fail
  service_redeploy inventory || task_fail
  service_redeploy audit || task_fail
  service_redeploy replic || task_fail
  service_redeploy store || task_fail
  service_redeploy access || task_fail
  service_redeploy ui || task_fail
  sleep 75

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services admintool ingest inventory audit replic store access ui || task_fail
  echo " ==> Service Wait Complete"

  service_redeploy merritt-ops || task_fail
  echo " ==> Merritt Ops Deployment Complete"
  
  stack_init
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_redeploy admintool || task_fail
  service_redeploy ui || task_fail
  service_redeploy merritt-ops || task_fail
  sleep 75

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
  --services admintool ui merritt-ops || task_fail
  echo " ==> Service Wait Complete"

  stack_init
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploy LDAP"
  /redeploy-ldap.sh || task_fail

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_retag_redeploy audit || task_fail
  service_retag_redeploy access || task_fail
  service_retag_redeploy ui || task_fail
  service_retag_redeploy replic || task_fail
  service_retag_redeploy admintool || task_fail
  service_redeploy merritt-ops || task_fail
  sleep 120

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services audit access ui replic admintool merritt-ops || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Pause Ingest and Redeploy Services"
  pause_ingest || task_fail
  service_retag_redeploy inventory || task_fail

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services inventory || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Unpause Ingest"
  unpause_ingest || task_fail
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  # echo " ==> Redeploy LDAP"
  # /redeploy-ldap.sh || task_fail

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_retag_redeploy audit || task_fail
  service_retag_redeploy access || task_fail
  service_retag_redeploy ui || task_fail
  service_retag_redeploy replic || task_fail
  service_retag_redeploy admintool || task_fail
  service_redeploy merritt-ops || task_fail
  sleep 120

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services audit access ui replic admintool merritt-ops || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Pause Ingest and Redeploy Services"
  pause_ingest || task_fail
  service_retag_redeploy inventory || task_fail

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services inventory || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Unpause Ingest"
  unpause_ingest || task_fail
fi

task_complete