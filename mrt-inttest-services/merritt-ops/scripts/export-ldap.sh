#! /bin/bash

source ./ecs-helpers.sh

export label="Export LDAP"
export statfile="/tmp/export-ldap.txt"

task_init

datetime=$(TZ="America/Los_Angeles" date "+%Y-%m-%d_%H:%M")
filename="${1:-export.${datetime}.ldif}"

ldap=$(aws ecs list-tasks --cluster mrt-ecs-dev-stack --service-name ldap --query taskArns --output text)

aws ecs execute-command --cluster $ECS_STACK_NAME --task $ldap \
  --container ldap --command "/opt/opendj/merritt-export.sh" --interactive

echo "TBD export ${filename} to S3"

task_complete