#! /bin/bash

source ./ecs-helpers.sh

export label="Export ZK"
export statfile="/tmp/export-zk.txt"

task_init

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

echo " ==> ZK Snapshot (cluster data will persist through re-deploy)"
zk_snapshot
sleep 30

task_complete