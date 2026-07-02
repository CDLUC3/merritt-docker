#! /bin/bash

source ./ecs-helpers.sh

export label="Redeploy Stack"
export statfile="/tmp/redeploy-log.txt"

task_init

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Pause Ingest"
  pause_ingest || task_fail

  echo " ==> Redeploy LDAP"
  /redeploy-ldap.sh || task_fail

  echo " ==> Redeploying Merritt Services"
  service_redeploy admintool || task_fail
  service_redeploy inventory || task_fail
  service_redeploy audit || task_fail
  service_redeploy replic || task_fail
  service_redeploy access || task_fail
  service_redeploy ui || task_fail
  service_redeploy ingest || task_fail
  service_redeploy inventory || task_fail
  service_redeploy store || task_fail
  sleep 75

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services admintool audit replic access ui ingest inventory store || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Unpause Ingest"
  unpause_ingest || task_fail

  # Initialize the stack if needed
  # The dev environment has been designed to allow itself to initialize from an empty database
  stack_init

  echo " ==> Launch End-to-End Tests"
  launch_end2end_tests || task_fail

  service_redeploy merritt-ops || task_fail
  echo " ==> Merritt Ops Redployment Initiated"
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
  echo " ==> Merritt Ops Redployment Initiated"
  
  stack_init
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_redeploy admintool || task_fail
  service_redeploy ui || task_fail
  sleep 75

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
  --services admintool ui || task_fail
  echo " ==> Service Wait Complete"

  stack_init

  service_redeploy merritt-ops || task_fail
  echo " ==> Merritt Ops Redployment Initiated"
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Pause Ingest"
  pause_ingest || task_fail

  echo " ==> Redeploy LDAP"
  /redeploy-ldap.sh || task_fail

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_retag_redeploy audit || task_fail
  service_retag_redeploy access || task_fail
  service_retag_redeploy ui || task_fail
  service_retag_redeploy replic || task_fail
  service_retag_redeploy admintool || task_fail
  service_retag_redeploy inventory || task_fail
  sleep 120

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services audit access ui replic admintool inventory || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Unpause Ingest"
  unpause_ingest || task_fail

  echo " ==> Launch End-to-End Tests"
  launch_end2end_tests || task_fail

  service_redeploy merritt-ops || task_fail
  echo " ==> Merritt Ops Redployment Initiated"
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo " ==> Pause Ingest"
  pause_ingest || task_fail

  echo " ==> Redeploy LDAP"
  /redeploy-ldap.sh || task_fail

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_retag_redeploy audit || task_fail
  service_retag_redeploy access || task_fail
  service_retag_redeploy ui || task_fail
  service_retag_redeploy replic || task_fail
  service_retag_redeploy admintool || task_fail
  service_retag_redeploy inventory || task_fail
  sleep 120

  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME \
    --services audit access ui replic admintool inventory || task_fail
  echo " ==> Service Wait Complete"

  echo " ==> Unpause Ingest"
  unpause_ingest || task_fail

  echo " ==> Launch End-to-End Tests"
  launch_end2end_tests || task_fail

  service_redeploy merritt-ops || task_fail
  echo " ==> Merritt Ops Redployment Initiated"
fi

export SLACK_ONSUCCESS=Y
task_complete