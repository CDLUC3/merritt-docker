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
REPOS_DIR="$SCRIPT_HOME/../mrt-inttest-services"
cd $REPOS_DIR

echo "Setup ECS login"
echo "ECR_REGISTRY: $ECR_REGISTRY"
aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY} || exit 1

echo
echo "Building mock-merritt-it"
docker-compose -f mock-merritt-it/docker-compose.yml build --pull
docker-compose -f mock-merritt-it/docker-compose.yml push

echo
echo "Building mrt-it-database"
docker-compose -f mrt-it-database/docker-compose.yml build --pull
docker-compose -f mrt-it-database/docker-compose.yml push

echo "Building mrt-it-database-audit-replic"
docker-compose -f mrt-it-database/docker-compose-audit-replic.yml build --pull
docker-compose -f mrt-it-database/docker-compose-audit-replic.yml push

echo
echo "Building mrt-minio-it"
docker-compose -f mrt-minio-it/docker-compose.yml build --pull
docker-compose -f mrt-minio-it/docker-compose.yml push

echo
echo "Building mrt-minio-with-content-it"
docker-compose -f mrt-minio-it-with-content/docker-compose.yml build --pull
docker-compose -f mrt-minio-it-with-content/docker-compose.yml push
