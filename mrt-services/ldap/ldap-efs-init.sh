#!/bin/bash

EXCLUDE="^(entryUUID|creatorsName|modifyTimestamp|modifiersName|createTimestamp|pwdChangedTime|ds-sync-hist)"

sanitize_exported_ldif() {
  bin/ldifmodify -c "$1" /opt/fixup.ldif | egrep -v "$EXCLUDE" > "$2"
}

if [[ "$LDAP_RESET" == "true" ]]
then
  echo "force delete of opendj database"
  rm -rf /opt/opendj/data/*
fi

if [ -d /opt/opendj/data/db/userRoot ]
then
  echo "database already exists, skipping setup"
else
  cp /opt/99-user.ldif /opt/opendj/template/config/schema
  mkdir -p /opt/opendj/bootstrap/data

  if [ -f /opt/import/import.ldif ]
  then
    echo "import file found, loading data from /opt/import/import.ldif"
    sanitize_exported_ldif /opt/import/import.ldif /opt/opendj/bootstrap/data/import.ldif
    mv /opt/import/import.ldif /opt/import/import.ldif.loaded
  else
    echo "no import file found, loading data from /opt/barebones.ldif"
    sanitize_exported_ldif /opt/barebones.ldif /opt/opendj/bootstrap/data/barebones.ldif
  fi
fi

#/opt/opendj/run.sh --baseDN "$BASE_DN"
/opt/opendj/run.sh 