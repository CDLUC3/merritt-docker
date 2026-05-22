#! /bin/bash
source ./ecs-helpers.sh

export label="Consistency Checks"
export statfile="/tmp/consistency-log.txt"

task_init

FAIL=0
set -o pipefail
admintool_run_consistency_checks  | tee -a $statfile || FAIL=1
set +o pipefail

if [ $FAIL -eq 1 ]
then
  echo '```' > $statfile.slack
  head -6 $statfile > $statfile.slack
  echo '```' >> $statfile.slack
  echo "" >> $statfile.slack
fi

echo "- ${baseurl}queries/consistency/daily" > $statfile.slack

if [ $FAIL -eq 1 ]
then
  task_fail
else
  task_complete
fi