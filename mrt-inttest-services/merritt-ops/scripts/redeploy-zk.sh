#! /bin/bash

source ./ecs-helpers.sh

export label="Redeploy ZK"
export statfile="/tmp/redeploy-zk.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

echo " ==> ZK Snapshot (cluster data will persist through re-deploy)"
zk_snapshot
sleep 30

for zknode in $(zoo_nodes)
do
  echo " ==> Redeploying $zknode"
  aws ecs update-service --cluster $ECS_STACK_NAME --service $zknode --force-new-deployment --desired-count 1 \
    --query 'service.{service:serviceName,status:status,desired:desiredCount,running:runningCount}' --output text --no-cli-pager 
  sleep 30
  echo " ==> Begin Service Wait"
  aws ecs wait services-stable --cluster $ECS_STACK_NAME --services $zknode
done

if [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  echo " ==> ZK Restore (needed since only one not is active)"
  zk_restore
fi

task_complete