#! /bin/bash

if [[ -z $BUCKET8888 ]]; then
  echo "Environment variable BUCKET8888 only defined for DEV environments"
  exit 1
fi

if [[ "$MERRITT_ECS" == "docker" || "$MERRITT_ECS" == "ecs-ephemeral" ]]
then
  export AWS_PROFILE=minio
  export AWS_REGION=us-east-1
fi

arkp1=ark:/99999/
arkp2=$(aws s3 ls s3://$BUCKET8888/$arkp1 | cut -c32- | grep system | tail -1)

aws s3 cp s3://$BUCKET8888/${arkp1}${arkp2}mrt-mom.txt /tmp/mrt-mom.txt
echo 'error' >> /tmp/mrt-mom.txt
aws s3 cp /tmp/mrt-mom.txt s3://$BUCKET8888/${arkp1}${arkp2}

aws s3 cp s3://$BUCKET8888/${arkp1}${arkp2}mrt-ingest.txt /tmp/mrt-ingest.txt
sed -i -e 's/e/a/g' /tmp/mrt-ingest.txt
aws s3 cp /tmp/mrt-ingest.txt s3://$BUCKET8888/${arkp1}${arkp2}