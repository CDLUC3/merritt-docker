#! /bin/bash

source ./ecs-helpers.sh

# This is intended for testing

if [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  exit
fi

# run stop-ldap.sh

rm -rf /merritt-filesys/ldap/data/*
rm -rf /merritt-filesys/ldapreplica/data/*

# use the last import file...
mv /merritt-filesys/ldap/import/import.ldif.loaded /merritt-filesys/ldap/import/import.ldif

# use the last S3 export file...
# aws s3 cp s3://${S3CONFIG_BUCKET}/uc3/mrt/ldap/${MERRITT_ECS/ecs-/}/backup/export.latest.ldif /merritt-filesys/ldap/import/import.ldif

chown opendj:ubuntu /merritt-filesys/ldap/import/import.ldif

# run start-ldap.sh
