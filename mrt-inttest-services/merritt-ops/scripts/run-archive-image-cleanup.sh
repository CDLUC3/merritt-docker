#! /bin/bash

source ./ecs-helpers.sh

export label="Archive Image Cleanup"
export statfile="/tmp/archive-image-cleanup.txt"

task_init

post_route /source/archive-images 
jq . /tmp/curl.json

task_complete