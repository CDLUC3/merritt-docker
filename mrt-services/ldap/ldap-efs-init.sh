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
  elif [[ "$REPLICA" == "true" ]]
  then
    cp /opt/99-user.ldif /opt/opendj/template/config/schema
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

rm -rf /opt/opendj/data/logs/*
initialize_data

# technique to intialize from the entrypoint...
# /opt/opendj/run.sh & sleep 10
# /opt/opendj/bin/stop-ds

/opt/opendj/run.sh