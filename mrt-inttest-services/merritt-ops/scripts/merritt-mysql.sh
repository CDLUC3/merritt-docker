#! /bin/bash

DBHOST=db-container
DBUSER=user
DBPASS=password
DBDATABASE=inv

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/readwrite/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/readwrite/db-password --query Parameter.Value --with-decryption --output text)
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/dev/billing/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/dev/billing/readwrite/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/dev/billing/readwrite/db-password --query Parameter.Value --with-decryption --output text)
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/stg/inv/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/stg/inv/readwrite/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/stg/inv/readwrite/db-password --query Parameter.Value --with-decryption --output text)
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/readwrite/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/readwrite/db-password --query Parameter.Value --with-decryption --output text)
fi

mysql -h $DBHOST -u $DBUSER --password=$DBPASS --database=$DBDATABASE "$@"
