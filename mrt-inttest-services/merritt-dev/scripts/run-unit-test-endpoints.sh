#! /bin/bash

source ./ecs-helpers.sh

label=Admin Unit Tests
statfile="/tmp/admin-unit-log.txt"

task_init

admintool_test_routes

task_complete