#! /bin/bash

source ./ecs-helpers.sh

export label="Purge Recycle Bin"
export statfile="/tmp/recycle-bin-log.txt"

task_init

find /s3files/queue/RecycleBin -maxdepth 1  -name "jid-*" -mtime +7 | xargs rm -rf
find /s3files/queue/RecycleBin -maxdepth 1  -name "jid-*" -mtime +3h | xargs rm -rf

task_complete