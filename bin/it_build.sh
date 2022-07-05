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
echo "Building ezid-store-mock"
echo "Running docker build --pull -t ${ECR_REGISTRY}/mrt-ezid-store-mock:dev ezid-store-mock"
sleep 2
docker build --pull --force-rm -t ${ECR_REGISTRY}/mrt-ezid-store-mock:dev ezid-store-mock || exit 1
docker push ${ECR_REGISTRY}/mrt-ezid-store-mock:dev || exit 1

echo
echo "Building mrt-minio-it"
echo "Running docker build --pull -t ${ECR_REGISTRY}/mrt-minio-it:dev mrt-minio-it"
sleep 2
docker build --pull --force-rm -t ${ECR_REGISTRY}/mrt-minio-it:dev mrt-minio-it || exit 1
docker push ${ECR_REGISTRY}/mrt-minio-it:dev || exit 1

echo
echo "Building mrt-minio-with-content-it"
echo "Running docker build --pull -t ${ECR_REGISTRY}/mrt-minio-with-content-it:dev mrt-minio-with-content-it"
sleep 2
docker build --pull --force-rm -t ${ECR_REGISTRY}/mrt-minio-with-content-it:dev mrt-minio-with-content-it || exit 1
docker push ${ECR_REGISTRY}/mrt-minio-with-content-it:dev || exit 1
