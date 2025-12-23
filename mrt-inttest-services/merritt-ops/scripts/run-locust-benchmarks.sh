#! /bin/bash

source ./ecs-helpers.sh

export label="Locust Benchmarks"
export statfile="/tmp/locust-benchmarks.txt"

task_init

/mrt-locust/run_locust.sh > $statfile || task_fail

task_complete