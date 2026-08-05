#! /bin/bash
source ./ecs-helpers.sh

export label="Nuxeo Init"
export statfile="/tmp/nuxeo-init-log.txt"

task_init

NUXEO_DIR="/merritt-filesys/nuxeo/mrt-atom"
${NUXEO_DIR}/bin/nuxeoInit.sh || task_fail

task_complete
