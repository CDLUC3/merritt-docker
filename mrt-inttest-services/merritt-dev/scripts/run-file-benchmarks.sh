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
  stat=$(jq -r '.status' /tmp/benchmark.json)
  rettime=$(jq -r '.retrieval_time_sec' /tmp/benchmark.json)
  cloud=$(jq -r '.cloud_service' /tmp/benchmark.json)

  aws cloudwatch put-metric-data --region us-west-2 --namespace merritt \
    --dimensions "filename=$filename,cloud_service=$cloud,retrieval_method=$method" \
    --unit seconds --metric-name duration-sec --value $rettime

  printf "%s\t%s\t%s\t%s\t%s\t%6.2f\n" $filename $cloud $nodenum $method $stat $rettime >> $statfile
}

run_tests() {
  localid=$1
  filename=$2
  nodes=$3

  for node in $nodes
  do
    for method in access audit
    do
      benchmark_fixity Audit_benchmark_20mb 20_mb_random.dat $node $method
      benchmark_fixity Audit_benchmark_100mb 100_mb_random.dat $node $method
    done
  done

}

if [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  run_tests Audit_benchmark_20mb 20_mb_random.dat '5001 9501 2001'
fi

grep -qv "ERROR|FAIL" $statfile || task_fail

task_complete
