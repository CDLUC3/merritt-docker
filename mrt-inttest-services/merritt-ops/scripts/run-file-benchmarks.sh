#! /bin/bash

source ./ecs-helpers.sh

export label="File Benchmarks"
export statfile="/tmp/file-benchmarks.txt"

task_init

benchmark_fixity() {
  localid=$1
  filename=$2
  nodenum=$3
  method=$4
  
  base="$(admintool_base)/ops/storage/benchmark-fixity-localid"
  url="${base}?localid=${localid}&filename=${filename}&node_number=${nodenum}&retrieval_method=${method}"
  curl --no-progress-meter -o /tmp/benchmark.json "$url" 

  stat=$(jq -r '.results.status' /tmp/benchmark.json)
  rettime=$(jq -r '.results.retrieval_time_sec' /tmp/benchmark.json)
  cloud=$(jq -r '.cloud_service' /tmp/benchmark.json)
  errormsg=$(jq -r '.results.error_message // ""' /tmp/benchmark.json)

  aws cloudwatch put-metric-data --region us-west-2 --namespace merritt \
    --dimensions "filename=$filename,cloud_service=$cloud,retrieval_method=$method" \
    --unit Seconds --metric-name retrieval-duration-sec --value $rettime

  printf "%s\t%s\t%s\t%s\t%s\t%6.2f\t%s\n" $filename $cloud $nodenum $method $stat $rettime $errormsg | tee -a $statfile
}

run_tests() {
  localid=$1
  filename=$2
  nodes=$3

  for node in $nodes
  do
    for method in access audit
    do
      benchmark_fixity $localid $filename $node $method
    done
  done

}

if [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  run_tests Audit_benchmark_20mb 20_mb_random.dat '5001 9501 2001'
  run_tests Audit_benchmark_100mb 100_mb_random.dat '5001 9501 2001'
elif [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  run_tests 2025_10_20_0834_combo README.md '7777 8888'
fi

egrep -q "ERROR|FAIL|WARN" $statfile && task_fail

# do not send a report unless there is a failure
# task_complete
