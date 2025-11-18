#! /bin/bash

if [[ -z $BUCKET7777 ]]; then
  echo "Environment variable BUCKET7777 only defined for DEV environments"
  exit 1
fi

if [[ "$MERRITT_ECS" == "docker" || "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export AWS_PROFILE=minio
  export AWS_REGION=us-east-1
fi

echo 'hello' > /tmp/test.txt

aws s3 cp /tmp/test.txt s3://$BUCKET7777/scan-error.txt
aws s3 cp /tmp/test.txt s3://$BUCKET7777/ark:/00000/fk00000000/scan-error.txt

arkp1=ark:/99999/
arkp2=$(aws s3 ls s3://$BUCKET7777/$arkp1 | cut -c32- | grep producer | tail -1)
aws s3 cp /tmp/test.txt s3://$BUCKET7777/${arkp1}${arkp2}scan-error.txt
