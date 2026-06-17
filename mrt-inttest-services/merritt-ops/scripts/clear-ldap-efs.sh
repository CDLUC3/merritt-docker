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
mv /merritt-filesys/ldap/import/import.ldif.loaded /merritt-filesys/ldap/import/import.ldif

# run start-ldap.sh
