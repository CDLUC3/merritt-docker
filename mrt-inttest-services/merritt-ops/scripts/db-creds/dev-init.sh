#!/bin/bash

echo "Use copy/paste for these commands"
exit

user=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/super/db-user --query Parameter.Value --with-decryption --output text)
pass=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/super/db-password --query Parameter.Value --with-decryption --output text)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

user=travis
pass=password
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

user=user
pass=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/readwrite/db-password --query Parameter.Value --with-decryption --output text)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

