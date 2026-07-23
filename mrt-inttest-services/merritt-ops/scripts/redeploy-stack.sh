#! /bin/bash

source ./ecs-helpers.sh

export label="Redeploy Stack"
export statfile="/tmp/redeploy-log.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  echo " ==> Pause Ingest"
  pause_ingest || task_fail

  echo " ==> Redeploy ZK"
  /redeploy-zk.sh || task_fail

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
  aws autoscaling start-instance-refresh --auto-scaling-group-name merritt-ingest-proxy-asg
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
  echo " ==> Pause Ingest"
  pause_ingest || task_fail

  echo " ==> Redeploy LDAP"
  /redeploy-ldap.sh || task_fail

  echo " ==> Redeploy SMTP"
  aws ecs update-service --cluster $ECS_STACK_NAME --service smtp         --force-new-deployment --desired-count 1 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
    --output text --no-cli-pager 

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_retag_redeploy audit || task_fail
  service_retag_redeploy access || task_fail
  service_retag_redeploy ui || task_fail
  service_retag_redeploy replic || task_fail
  service_retag_redeploy admintool || task_fail
  service_retag_redeploy ingest || task_fail
  service_retag_redeploy inventory || task_fail
  service_retag_redeploy store || task_fail
  # stage does not have a proxy server of its own
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
  echo " ==> Pause Ingest"
  pause_ingest || task_fail

  echo " ==> Redeploy LDAP"
  /redeploy-ldap.sh || task_fail

  # echo " ==> Redeploy SMTP"
  # aws ecs update-service --cluster $ECS_STACK_NAME --service smtp         --force-new-deployment --desired-count 1 \
  #   --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
  #   --output text --no-cli-pager 

  echo " ==> Redeploying Merritt Services and Merritt Ops"
  service_retag_redeploy audit || task_fail
  service_retag_redeploy access || task_fail
  service_retag_redeploy ui || task_fail
  service_retag_redeploy replic || task_fail
  service_retag_redeploy admintool || task_fail
  service_retag_redeploy inventory || task_fail
  # service_retag_redeploy ingest || task_fail
  # service_retag_redeploy store || task_fail
  aws autoscaling start-instance-refresh --auto-scaling-group-name merritt-ingest-proxy-asg
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