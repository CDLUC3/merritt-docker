#!/usr/bin/env bash
#set -x

# get dir of this script
START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)

# cd into mrt-services
REPOS_DIR="$SCRIPT_HOME/../mrt-inttest-services"
cd $REPOS_DIR

export ECR_REGISTRY=it-docker-registry

echo
echo "Building mock-merritt-it"
docker-compose -f mock-merritt-it/docker-compose.yml build  || exit 1

echo
echo "Building mrt-it-database"
docker-compose -f mrt-it-database/docker-compose.yml build || exit 1

echo "Building mrt-it-database-audit-replic"
docker-compose -f mrt-it-database/docker-compose-audit-replic.yml build || exit 1

echo
echo "Building mrt-minio-it"
docker-compose -f mrt-minio-it/docker-compose.yml build || exit 1

echo
echo "Building mrt-minio-with-content-it"
docker-compose -f mrt-minio-it-with-content/docker-compose.yml build || exit 1

echo
echo "Building pm-server"
docker-compose -f pm-server/docker-compose.yml build || exit 1
