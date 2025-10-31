#! /bin/bash

case $MERRITT_ECS in
  "ecs-dev")
    aws s3 ls --recursive s3://${BUCKET7777}/ | cut -c 32- > /tmp/scanlist
    aws s3 cp /tmp/scanlist s3://${BUCKET8888}/scanlist/7777.log
    ;;
  "ecs-ephemeral","docker")
    aws s3 ls --profile minio-ephemeral --recursive s3://${BUCKET7777}/ | cut -c 32- > /tmp/scanlist
    aws s3 cp --profile minio-ephemeral /tmp/scanlist s3://${BUCKET8888}/scanlist/7777.log
    ;;
  *)
    echo "create-scanlist not supported for $MERRITT_ECS"
    exit
    ;;
esac
