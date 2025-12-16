#!/bin/bash

curl -s http://admintool:9292/ops/storage/storage-config?admintoolformat=json | jq -r ".table[][].command"