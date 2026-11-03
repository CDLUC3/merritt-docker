#!/bin/bash

echo "Use copy/paste for these commands"
exit

for user in invro_dloy invrw_dloy invro_elopatin
do
  pass=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/${user}/db-password --query Parameter.Value --with-decryption --output text)
  OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"
done

user=invdba
pass=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/dba/db-password --query Parameter.Value --with-decryption --output text)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

user=billingdba
pass=$(aws ssm get-parameter --name /uc3/mrt/prd/billing/dba/db-password --query Parameter.Value --with-decryption --output text)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

user=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/readonly/db-user --query Parameter.Value --with-decryption --output text)
pass=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/readonly/db-password --query Parameter.Value --with-decryption --output text)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

user=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/readwrite/db-user --query Parameter.Value --with-decryption --output text)
pass=$(aws ssm get-parameter --name /uc3/mrt/prd/inv/readwrite/db-password --query Parameter.Value --with-decryption --output text)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

user=$(aws ssm get-parameter --name /uc3/mrt/prd/billing/readwrite/db-user --query Parameter.Value --with-decryption --output text)
pass=$(aws ssm get-parameter --name /uc3/mrt/prd/billing/readwrite/db-password --query Parameter.Value --with-decryption --output text)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"

for user in billingro billingro2 invro invrw billingrw
do
  pass=$(openssl rand -base64 32)
  OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED WITH caching_sha2_password BY '$pass';"
done