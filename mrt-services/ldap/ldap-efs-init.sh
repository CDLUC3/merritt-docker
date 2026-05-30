#!/bin/bash

EXCLUDE="^(entryUUID|creatorsName|modifyTimestamp|modifiersName|createTimestamp|pwdChangedTime|ds-sync-hist)"

if [ -d /opt/opendj/data/db/userRoot ]
then
  echo "database already exists, skipping setup"
else
  if [ -f /opt/import/import.ldif ]
  then
    echo "import file found, loading data from /opt/import/import.ldif"
    cp /opt/99-user.ldif /opt/opendj/template/config/schema
    egrep -v "$EXCLUDE" /opt/import/import.ldif > /tmp/import.1.ldif
    bin/ldifmodify -o /tmp/import.2.ldif /tmp/import.1.ldif /opt/import/fixup.ldif
    mkdir -p /opt/opendj/bootstrap/data
    cp /tmp/import.2.ldif /opt/opendj/bootstrap/data/import.ldif
    mv /opt/import/import.ldif /opt/import/import.ldif.loaded
  else
    echo "no import file found, loading data from /opt/barebones.ldif"
    cp /opt/99-user.ldif /opt/opendj/template/config/schema
    mkdir -p /opt/opendj/bootstrap/data
    egrep -v "$EXCLUDE" \
      /opt/barebones.export.ldif > /opt/opendj/bootstrap/data/barebones.ldif
  fi
fi

#/opt/opendj/run.sh --baseDN "$BASE_DN"
/opt/opendj/run.sh 