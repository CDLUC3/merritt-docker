#!/bin/bash

EXCLUDE="^(entryUUID|creatorsName|modifyTimestamp|modifiersName|createTimestamp|pwdChangedTime|ds-sync-hist)"

sanitize_exported_ldif() {
  bin/ldifmodify -c "$1" /opt/fixup.ldif | egrep -v "$EXCLUDE" > "$2"
}

initialize_data() {
  if [ -d /opt/opendj/data/db/userRoot ]
  then
    echo "database already exists, skipping setup; cleaning logs/locks"
    rm -rf /opt/opendj/data/logs/*
    # rm -rf /opt/opendj/data/locks/*
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
}

if [[ "$LDAP_RESET" == "true" ]]
then
  echo "force delete of opendj database"
  rm -rf /opt/opendj/data/*
fi

if [[ "$REPLICA" == "true" ]]
then
  echo "is REPLICA, starting cleaning up logs"
  rm -rf /opt/opendj/data/logs/*
  /opt/opendj/run.sh
else
  echo "is PRIMARY, initialize data"
  initialize_data
  # technique to intialize from the entrypoint...
  # /opt/opendj/run.sh & sleep 10
  # /opt/opendj/bin/stop-ds
fi

/opt/opendj/run.sh