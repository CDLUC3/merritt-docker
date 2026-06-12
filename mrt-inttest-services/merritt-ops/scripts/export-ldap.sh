#! /bin/bash

source ./ecs-helpers.sh

export label="Export LDAP"
export statfile="/tmp/export-ldap.txt"

task_init

datetime=$(TZ="America/Los_Angeles" date "+%Y-%m-%d_%H:%M")
filename="${1:-export.${datetime}.ldif}"

ldap=$(aws ecs list-tasks --cluster $ECS_STACK_NAME --service-name ldap --query taskArns --output text)

# unbuffer prevents EOF errors.  See https://stackoverflow.com/a/71728047/3846548
unbuffer aws ecs execute-command --cluster $ECS_STACK_NAME --task $ldap \
  --container ldap --command "/opt/opendj/merritt-export.sh ${filename}" --interactive || task_fail

sleep 2

if [ -f /merritt-filesys/ldap/import/${filename} ]
then
  echo "Exported LDAP to /merritt-filesys/ldap/import/${filename}"
else
  echo "Export failed, file not found: /merritt-filesys/ldap/import/${filename}"
  task_fail
fi

path=s3://${S3CONFIG_BUCKET}/uc3/mrt/ldap/${MERRITT_ECS/ecs-/}/backup/${filename}
aws s3 cp /merritt-filesys/ldap/import/${filename} $path

echo "Exported LDAP to $path"

mv /merritt-filesys/ldap/import/${filename} /merritt-filesys/ldap/import/export.latest.ldif
path=s3://${S3CONFIG_BUCKET}/uc3/mrt/ldap/${MERRITT_ECS/ecs-/}/backup/export.latest.ldif
aws s3 cp /merritt-filesys/ldap/import/export.latest.ldif $path

echo "Exported LDAP to $path"

task_complete