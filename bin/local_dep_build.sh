#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR="$SCRIPT_HOME/../mrt-services"
cd $REPOS_DIR

export ECR_REGISTRY=it-docker-registry

echo
echo "Building dep_cdlmvn"
echo "Running docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn"
sleep 2
docker build --force-rm -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn || exit 1

echo
echo "Building mrt-core2"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core || exit 1

echo
echo "Building cdl-zk-queue"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk || exit 1

echo
echo "Building mrt-zoo"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo || exit 1

echo
echo "Building mrt-cloud"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud || exit 1

echo
echo "Building mrt-ingest"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest || exit 1

echo
echo "Building mrt-inventory-src"
echo "Running docker build -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory"
sleep 2
docker build --force-rm -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} \
  -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory || exit 1

echo
echo "Building mrt-inventory"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory || exit 1

echo
echo "Building mrt-store"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store || exit 1

echo
echo "Building mrt-audit"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit || exit 1

echo
echo "Building mrt-replic"
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic"
sleep 2
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic || exit 1