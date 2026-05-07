#! /bin/bash

source ./ecs-helpers.sh

export label="Prepare LDAP Import"
export statfile="/tmp/prepare-ldap-import-log.txt"

ldap_init() {
  echo "Initializing LDAP data for ECS environment: $MERRITT_ECS"
  rm -rf /merritt-filesys/ldap
  mkdir -p /merritt-filesys/ldap/config /merritt-filesys/ldap/db /merritt-filesys/ldap/import
  chmod 777 /merritt-filesys/ldap/config /merritt-filesys/ldap/db /merritt-filesys/ldap/import

  find /merritt-filesys/ldap -print

  if [[ "$MERRITT_ECS" == "ecs-stg" ]]
  then
    aws s3 cp s3://${S3CONFIG_BUCKET}/uc3/mrt/ldap/stg/backup/latest.ldif /merritt-filesys/ldap/import/import.ldif
  elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
  then
    aws s3 cp s3://${S3CONFIG_BUCKET}/uc3/mrt/ldap/prd/backup/latest.ldif /merritt-filesys/ldap/import/import.ldif
  fi
}

task_init

ldap_init

task_complete