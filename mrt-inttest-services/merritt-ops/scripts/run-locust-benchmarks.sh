#! /bin/bash

source ./ecs-helpers.sh

export label="Locust Benchmarks"
export statfile="/tmp/locust-benchmarks.txt"

task_init

# Return Code ignores tee
FAIL=0
set -o pipefail
/mrt-locust/run_locust.sh | tee -a $statfile || FAIL=1
set +o pipefail

rptfile="$(date +%Y%m%d-%H%M%S).txt"
aws s3 cp $statfile "s3://${S3REPORT_BUCKET}/locust/${rptfile}"

mv $statfile $statfile.tmp

echo "To see a formatted version of the report, copy and paste the following URL into a browser:" >> $statfile
echo "" >> $statfile
echo "${baseurl}ops/s3-reports/retrieve?report=locust%2F${rptfile}" >> $statfile
echo "" >> $statfile
cat $statfile.tmp >> $statfile

export SLACK_BOT_TOKEN=$(aws ssm get-parameter --name "${SLACK_BOT_SSM}" --with-decryption --query "Parameter.Value" --output text)

if [ $FAIL -eq 1 ]
then
  task_fail N
  ruby slack_message.rb $statfile
else
  task_complete
fi