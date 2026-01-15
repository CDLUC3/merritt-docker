#! /bin/bash

source ./ecs-helpers.sh

export label="Locust Benchmarks"
export statfile="/tmp/locust-benchmarks.txt"

task_init

# Return Code ignores tee 
set -o pipefail
/mrt-locust/run_locust.sh | tee -a $statfile || task_fail
set +o pipefail

task_complete