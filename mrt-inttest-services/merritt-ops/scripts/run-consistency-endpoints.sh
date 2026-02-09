#! /bin/bash
source ./ecs-helpers.sh

export label="Consistency Checks"
export statfile="/tmp/consistency-log.txt"

task_init

set -o pipefail
admintool_run_consistency_checks  | tee -a $statfile || task_fail
set +o pipefail

task_complete