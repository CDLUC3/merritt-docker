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

echo "- ${baseurl}ops/s3-reports/retrieve?report=locust%2F${rptfile}" > $statfile.slack

if [ $FAIL -eq 1 ]
then
  task_fail
else
  task_complete
fi