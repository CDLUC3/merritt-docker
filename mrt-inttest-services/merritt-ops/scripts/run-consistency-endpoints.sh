#! /bin/bash
source ./ecs-helpers.sh

export label="Consistency Checks"
export statfile="/tmp/consistency-log.txt"

task_init

set -o pipefail
FAIL=0
admintool_run_consistency_checks  | tee -a $statfile || FAIL=1
set +o pipefail

echo "- ${baseurl}queries/consistency/daily" > $statfile.slack

if [ $FAIL -eq 1 ]
then
  task_fail
else
  task_complete
fi