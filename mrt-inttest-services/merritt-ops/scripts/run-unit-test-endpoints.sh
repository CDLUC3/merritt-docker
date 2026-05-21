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

echo "To see a formatted version of the report, copy and paste the following URL into a browser:" >> $statfile.slack
echo "" >> $statfile.slack
echo "${baseurl}ops/s3-reports/unit-test-results?report=unit-tests%2F${rptfile}" >> $statfile.slack
echo "" >> $statfile.slack

export SLACK_BOT_TOKEN=$(aws ssm get-parameter --name "${SLACK_BOT_SSM}" --with-decryption --query "Parameter.Value" --output text)

if [ $FAIL -eq 1 ]
then
  task_fail N
  ruby slack_message.rb $statfile.slack
else
  task_complete
  ruby slack_message.rb $statfile.slack
fi