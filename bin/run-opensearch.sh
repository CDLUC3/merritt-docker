#!/usr/bin/env bash
#
# A simple launcher scriptlet to wrap common docker-compose commands


usage() {
  echo "Usage: $(basename $0) <up|down>"
  exit 1
}

START_DIR=$(pwd)
SCRIPT_HOME=$(dirname $0)
SERVICES_DIR=$(realpath $SCRIPT_HOME/../mrt-services)

if [ -z "$AWS_ACCOUNT_ID" ]; then
  [ -f "$SCRIPT_HOME/docker_enviroment.sh" ] && . "$SCRIPT_HOME/docker_enviroment.sh" 
fi

cd $SERVICES_DIR
case $1 in
  up)     docker-compose -p merritt -f docker-compose.yml -f ec2.yml -f opensearch.yml up -d --build;;
  down)   docker-compose -p merritt -f docker-compose.yml -f ec2.yml -f opensearch.yml down;;
  *)      usage;
esac
