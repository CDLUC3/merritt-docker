#! /bin/bash

source ./ecs-helpers.sh

export label="Purge Recycle Bin"
export statfile="/tmp/recycle-bin-log.txt"

task_init

# Replace -mtime X with -mmin X to use minutes instead of days.

# Find recycle bin folders older than 7 days
find /merritt-filesys/ingest/queue/RecycleBin -maxdepth 1  -name "jid-*" -mtime +7 | xargs rm -rf

# Find batch folders older than 30 days that do not still contain a producer directory
# The checkm files within these folders are occasionally used for troubleshooting.
oldbids=$(find /merritt-filesys/ingest/queue -maxdepth 1 -name "bid-*" -mtime +30)
for f in $oldbids
do
  # compgen is a bash utility that can evaluate wildcards
  compgen -G "$f/jid-*/producer" > /dev/null || continue
  echo "Removing old batch folder: $f"
  rm -rf $f
done

task_complete