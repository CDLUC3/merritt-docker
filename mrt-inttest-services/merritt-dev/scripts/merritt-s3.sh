#! /bin/bash

if [[ "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export AWS_REGION=us-east-1
  export AWS_ACCESS_KEY_ID=minioadmin
  export AWS_SECRET_ACCESS_KEY=minioadmin
  S3ARGS="--endpoint-url=http://minio:9000"
elif [[ "$MERRITT_ECS" == "ecs-dev" || "$MERRITT_ECS" == "ecs-stg" || "$MERRITT_ECS" == "ecs-prd" ]]
then
  S3ARGS=
else
  export AWS_REGION=us-east-1
  export AWS_ACCESS_KEY_ID=minioadmin
  export AWS_SECRET_ACCESS_KEY=minioadmin
  S3ARGS="--endpoint-url=http://minio:8088"
fi

aws $S3ARGS s3 "$@"
