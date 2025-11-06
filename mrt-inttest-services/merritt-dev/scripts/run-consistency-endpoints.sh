#! /bin/bash
source ./ecs-helpers.sh

export label="Consistency Checks"
export statfile="/tmp/consistency-log.txt"

task_init

admintool_run_consistency_checks || task_fail

task_complete