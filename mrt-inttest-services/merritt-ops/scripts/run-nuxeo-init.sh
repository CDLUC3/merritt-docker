#! /bin/bash
source ./ecs-helpers.sh

export label="Nuxeo Init"
export statfile="/tmp/nuxeo-init-log.txt"

task_init

/mrt-atom/bin/nuxeoInit.sh || task_fail

task_complete
