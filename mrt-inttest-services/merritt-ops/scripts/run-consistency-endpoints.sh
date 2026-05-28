#! /bin/bash
source ./ecs-helpers.sh

export label="Consistency Checks"
export statfile="/tmp/consistency-log.txt"

task_init

FAIL=0
set -o pipefail
admintool_run_consistency_checks  | tee -a $statfile || FAIL=1
set +o pipefail

egrep -q "FAIL|ERROR|Status:500" $statfile 

if [ $? -eq 0 ]
then
  echo 'Snippet of failures (up to 10):' > $statfile.slack
  echo '```' >> $statfile.slack
  egrep "FAIL|ERROR|Status:500" $statfile | head -10 >> $statfile.slack
  echo '```' >> $statfile.slack
  echo "" >> $statfile.slack
  export COMPLETE_ICON=":exclamation:"
fi

echo "- ${baseurl}queries/consistency/daily" >> $statfile.slack

if [ $FAIL -eq 1 ]
then
  task_fail
else
  task_complete
fi