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