#! /bin/bash

source ./ecs-helpers.sh

export label=Admin Unit Tests
export statfile="/tmp/admin-unit-log.txt"

task_init

admintool_test_routes

task_complete