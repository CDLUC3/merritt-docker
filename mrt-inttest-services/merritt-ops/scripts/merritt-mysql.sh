#! /bin/bash

DBHOST=db-container
DBUSER=user
DBPASS=password
DBDATABASE=inv

if [[ "${OPS_MODE}" == "readwrite" ]]
then
  OPSMODE_PARAM="readwrite"
else
  OPSMODE_PARAM="readonly"
fi

if [[ "$MERRITT_ECS" == "ecs-dev" ]]
then
  # for dev environments, readonly credentials are not needed
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/readwrite/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/readwrite/db-password --query Parameter.Value --with-decryption --output text)
elif [[ "$MERRITT_ECS" == "ecs-dbsnapshot" ]]
then
  # for dev environments, readonly credentials are not needed
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/dev/billing/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/dev/billing/readwrite/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/dev/billing/readwrite/db-password --query Parameter.Value --with-decryption --output text)
elif [[ "$MERRITT_ECS" == "ecs-stg" ]]
then
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/stg/inv/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/stg/inv/${OPSMODE_PARAM}/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/stg/inv/${OPSMODE_PARAM}/db-password --query Parameter.Value --with-decryption --output text)
elif [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  DBHOST=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/db-host --query Parameter.Value --output text)
  DBUSER=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/${OPSMODE_PARAM}/db-user --query Parameter.Value --output text)
  DBPASS=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/${OPSMODE_PARAM}/db-password --query Parameter.Value --with-decryption --output text)
fi

MYSQL_PWD=$DBPASS mysql -h $DBHOST -u $DBUSER --password=$DBPASS --database=$DBDATABASE "$@"
