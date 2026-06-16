#! /bin/bash

source ./ecs-helpers.sh

export label="Redeploy LDAP"
export statfile="/tmp/redeploy-ldap.txt"

task_init

if [[ "$MERRITT_ECS" == "ecs-dev" || "$MERRITT_ECS" == "ecs-stg" || "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  # echo " ==> LDAP Snapshot (cluster data will persist through re-deploy)"
  # ldap_snapshot
  # sleep 30

  echo " ==> Redeploying ldap"
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap --force-new-deployment --desired-count 1 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
    --output text --no-cli-pager || task_fail
  sleep 120
  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services ldap || task_fail

  echo " ==> Redeploying ldapreplica"
  aws ecs update-service --cluster $ECS_STACK_NAME --service ldapreplica --force-new-deployment --desired-count 1 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' \
     --output text --no-cli-pager || task_fail
  sleep 120
  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services ldapreplica || task_fail

  echo " ==> Configure Replication"
  ldap=$(aws ecs list-tasks --cluster $ECS_STACK_NAME --service-name ldap --query taskArns --output text)
  ldapreplica=$(aws ecs list-tasks --cluster $ECS_STACK_NAME --service-name ldapreplica --query taskArns --output text)

  aws ecs execute-command --cluster $ECS_STACK_NAME --task $ldap \
    --container ldap --command "/opt/opendj/merritt-replication-init.sh" --interactive || task_fail

  aws ecs execute-command --cluster $ECS_STACK_NAME --task $ldapreplica \
    --container ldapreplica --command "/opt/opendj/merritt-replication-init.sh" --interactive || task_fail
elif [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  aws ecs update-service --cluster $ECS_STACK_NAME --service ldap --force-new-deployment --desired-count 1 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' --output text --no-cli-pager 
  sleep 30
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services ldap
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo "No action"
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo "Not yet implemented - will cycle ldap and ldapreplica"
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

  echo "Not yet implemented - will cycle ldap and ldapreplica"
fi

task_complete