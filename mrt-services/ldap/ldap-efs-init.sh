#!/bin/bash

EXCLUDE="^(entryUUID|creatorsName|modifyTimestamp|modifiersName|createTimestamp|pwdChangedTime|ds-sync-hist)"

sanitize_exported_ldif() {
  # bin/ldifmodify -c "$1" /opt/fixup.ldif | egrep -v "$EXCLUDE" > "$2"
  cat "$1" | egrep -v "$EXCLUDE" > "$2"
}

sanitize_barebones_ldif() {
  cat "$1" | egrep -v "$EXCLUDE" > "$2"
}

initialize_data() {
  rm -rf /opt/opendj/data/logs/*

  if [ -d /opt/opendj/data/db/userRoot ]
  then
    echo "database already exists, skipping setup"
  elif [[ "$REPLICA" == "true" ]]
  then
    echo "replica, skipping data initialization"
    # cp /opt/99-user.ldif /opt/opendj/template/config/schema
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
      sanitize_barebones_ldif /opt/barebones.ldif /opt/opendj/bootstrap/data/barebones.ldif
    fi
  fi
}

initialize_data

if [[ "$REPLICA" != "true" ]]
then
  bin/dsconfig -h localhost -p 4444 -D "cn=directory manager" -X -n \
    -w "$ROOT_PASSWORD" \
    set-password-policy-prop \
    --policy-name "Default Password Policy" \
    --set "last-login-time-attribute:ds-pwp-last-login-time" \
    --set "last-login-time-format:yyyy-MM-dd HH:mm:ss"
fi

# technique to intialize from the entrypoint...
# /opt/opendj/run.sh & sleep 10
# /opt/opendj/bin/stop-ds

/opt/opendj/run.sh