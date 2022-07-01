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

echo
echo "Building dep_cdlmvn"
echo "Running docker build --pull -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn"
sleep 2
docker build --pull --force-rm -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn || exit 1
docker push ${ECR_REGISTRY}/dep-cdlmvn:dev || exit 1

echo
echo "Building mrt-core2"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core || exit 1
docker push ${ECR_REGISTRY}/mrt-core2:dev || exit 1

echo
echo "Building cdl-zk-queue"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk || exit 1
docker push ${ECR_REGISTRY}/cdl-zk-queue:dev || exit 1

echo
echo "Building mrt-zoo"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo || exit 1
docker push ${ECR_REGISTRY}/mrt-zoo:dev || exit 1

echo
echo "Building mrt-cloud"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud || exit 1
docker push ${ECR_REGISTRY}/mrt-cloud:dev || exit 1

echo
echo "Building mrt-ingest"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest || exit 1
docker push ${ECR_REGISTRY}/mrt-ingest:dev || exit 1

echo
echo "Building mrt-inventory-src"
echo "Running docker build --pull -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory"
sleep 2
docker build --pull --force-rm -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} \
  -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory || exit 1
docker push ${ECR_REGISTRY}/mrt-inventory-src:dev || exit 1

echo
echo "Building mrt-inventory"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory || exit 1
docker push ${ECR_REGISTRY}/mrt-inventory:dev || exit 1

echo
echo "Building mrt-store"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store || exit 1
docker push ${ECR_REGISTRY}/mrt-store:dev || exit 1

echo
echo "Building mrt-audit"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit || exit 1
docker push ${ECR_REGISTRY}/mrt-audit:dev || exit 1

echo
echo "Building mrt-replic"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic || exit 1
docker push ${ECR_REGISTRY}/mrt-replic:dev || exit 1

echo
echo "Building mrt-oai"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-oai:dev oai"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-oai:dev oai || exit 1
docker push ${ECR_REGISTRY}/mrt-oai:dev || exit 1

echo
echo "Building mrt-sword"
echo "Running docker build --pull --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-sword:dev sword"
sleep 2
docker build --pull --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-sword:dev sword || exit 1
docker push ${ECR_REGISTRY}/mrt-sword:dev || exit 1

echo
echo "eh bede bede... That's all folks!"
echo
echo
