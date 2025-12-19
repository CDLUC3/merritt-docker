#! /bin/bash

source ./ecs-helpers.sh

export label="Locust Benchmarks"
export statfile="/tmp/locust-benchmarks.txt"

task_init

echo 'This is a placeholder script' || task_fail

task_complete