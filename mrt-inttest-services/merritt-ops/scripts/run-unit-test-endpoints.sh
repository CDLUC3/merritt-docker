#! /bin/bash

source ./ecs-helpers.sh

export label="Admin Unit Tests"
export statfile="/tmp/admin-unit-log.txt"

task_init

FAIL=0
set -o pipefail
admintool_test_routes | tee -a $statfile || FAIL=1
set +o pipefail

rptfile="$(date +%Y%m%d-%H%M%S).txt"
aws s3 cp $statfile "s3://${S3REPORT_BUCKET}/unit-tests/${rptfile}"

echo "${baseurl}ops/s3-reports/unit-test-results?report=unit-tests%2F${rptfile}" > $statfile.slack

if [ $FAIL -eq 1 ]
then
  task_fail
else
  task_complete Y
fi