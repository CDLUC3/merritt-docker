#! /bin/bash

source ./ecs-helpers.sh

export label="Admin Unit Tests"
export statfile="/tmp/admin-unit-log.txt"

task_init

set -o pipefail
admintool_test_routes | tee -a $statfile || task_fail
set +o pipefail

task_complete