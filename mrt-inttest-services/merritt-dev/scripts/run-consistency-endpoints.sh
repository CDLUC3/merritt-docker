#! /bin/bash
source ./ecs-helpers.sh

label=Consistency Checks
statfile="/tmp/consistency-log.txt"

task_init

admintool_run_consistency_checks

task_complete