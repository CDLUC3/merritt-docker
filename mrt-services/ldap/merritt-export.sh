#!/bin/bash
datetime=$(TZ="America/Los_Angeles" date "+%Y-%m-%d_%H:%M")
filename="${1:-export.${datetime}.ldif}"

if [[ "$REPLICA" == "true" ]]
then
  echo "is REPLICA, skipping export"
else
  datetime=$(TZ="America/Los_Angeles" date "+%Y-%m-%d_%H:%M:%S")
  bin/export-ldif --backendID userRoot --bindPassword $ROOT_PASSWORD --ldifFile /opt/import/${filename}
fi