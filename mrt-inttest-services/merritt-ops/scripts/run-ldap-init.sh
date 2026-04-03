#! /bin/bash

source ./ecs-helpers.sh

export label="Run LDAP Init"
export statfile="/tmp/run-ldap-init-log.txt"

task_init

rm -rf /merritt-filesys/ldap
mkdir -p /merritt-filesys/ldap/config /merritt-filesys/ldap/db
chmod 666 /merritt-filesys/ldap/config /merritt-filesys/ldap/db

if [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  aws s3 cp s3://${S3CONFIG_BUCKET}/uc3/mrt/ldap/stg/backup/latest.ldif /merritt-filesys/ldap/barebones.ldif
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  aws s3 cp s3://${S3CONFIG_BUCKET}/uc3/mrt/ldap/prd/backup/latest.ldif /merritt-filesys/ldap/barebones.ldif
fi

task_complete