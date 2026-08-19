#! /bin/bash

source ./ecs-helpers.sh

export label="Purge Recycle Bin"
export statfile="/tmp/recycle-bin-log.txt"

task_init

find /s3filesys/queue/RecycleBin -maxdepth 1  -name "jid-*" -mtime +7 | xargs rm -rf
# find /s3filesys/queue/RecycleBin -maxdepth 1  -name "jid-*" -mmin +180 | xargs rm -rf

task_complete