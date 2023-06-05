#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)
DOCKER_ENV_FILE=$SCRIPT_HOME/docker_environment.sh

# source env vars
echo "Setting up docker environment"
[ -f "$DOCKER_ENV_FILE" ] && . "$DOCKER_ENV_FILE" || echo "file $DOCKER_ENV_FILE not found"

# cd into mrt-services
REPOS_DIR="$SCRIPT_HOME/../mrt-services"
cd $REPOS_DIR

echo "Setup ECS login"
echo "ECR_REGISTRY: $ECR_REGISTRY"
aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY} || exit 1

# Java Images - resolved several issues by switching maven:3-jdk-8 to 3.9-eclipse-temurin-8-alpine
# and by tidying up some artifacts left by the build
# ---------------------------------
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/dep-cdlmvn:dev 
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-core2:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/cdl-zk-queue:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-zoo:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-cloud:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-ingest:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-inventory-src:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-inventory:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-store:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-audit:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-replic:dev

# the following have issues
~/trivy/trivy --scanners vuln image --severity CRITICAL openjdk:11-jre-buster
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-opendj

# ruby images
# ---------------------------------
~/trivy/trivy --scanners vuln image --severity CRITICAL ruby:3
~/trivy/trivy --scanners vuln image --severity CRITICAL --ignore-unfixed ruby:3
~/trivy/trivy --scanners vuln image --severity CRITICAL --ignore-unfixed ${ECR_REGISTRY}/callback
~/trivy/trivy --scanners vuln image --severity CRITICAL --ignore-unfixed ${ECR_REGISTRY}/mock-merritt-it:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL --ignore-unfixed ${ECR_REGISTRY}/pm-server:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL --ignore-unfixed ${ECR_REGISTRY}/mrt-dashboard
~/trivy/trivy --scanners vuln image --severity CRITICAL public.ecr.aws/lambda/ruby:2.7
~/trivy/trivy --scanners vuln image --severity CRITICAL public.ecr.aws/lambda/ruby:3
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mysql-ruby-lambda
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/uc3-mrt-admin-lambda:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/uc3-mrt-colladmin-lambda:dev

# note that libarchive-tools adds 2 unfixable vulnerabilities
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-integ-tests

# no longer used
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/simulate-lambda-alb

# mysql
# ---------------------------------
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-it-database:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-it-database-audit-replic:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-database

# minio
# ---------------------------------
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-minio-it:dev
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-minio-it-with-content:dev

# other images
# ---------------------------------
~/trivy/trivy --scanners vuln image --severity CRITICAL zookeeper
~/trivy/trivy --scanners vuln image --severity CRITICAL ghusta/fakesmtp
~/trivy/trivy --scanners vuln image --severity CRITICAL opensearchproject/opensearch
~/trivy/trivy --scanners vuln image --severity CRITICAL opensearchproject/opensearch-dashboards

#   ubuntu + curl
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/mrt-init

# other images - investigate issues
# ---------------------------------
~/trivy/trivy --scanners vuln image --severity CRITICAL opensearchproject/logstash-oss-with-opensearch-output-plugin
~/trivy/trivy --scanners vuln image --severity CRITICAL ${ECR_REGISTRY}/logstash-oss:dev

~/trivy/trivy --scanners vuln image --severity CRITICAL selenium/standalone-chrome
~/trivy/trivy --scanners vuln image --severity CRITICAL standalone-chrome-download-folder