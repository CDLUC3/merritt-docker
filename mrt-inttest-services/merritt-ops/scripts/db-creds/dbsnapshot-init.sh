#!/bin/bash

echo "Use copy/paste for these commands"
exit

pass=$(openssl rand -base64 32)
aws ssm put-parameter --name /uc3/mrt/dev/billing/super/db-password --type SecureString --value "$pass" --overwrite

# Use port forwarding to connect to the dbsnapshot database
# use the production superuser credential to connect
# alter user 'invsuper'@'%' identified by '???';

OPSMODE_PARAM=super /merritt-mysql.sh << HERE
drop user invro_dloy;
drop user invrw_dloy;
drop user invro_elopatin;
HERE

for user in billingro billingro2 invro invro2 invrw invrw2 invdba billingrw2
do
  pass=$(openssl rand -base64 32)
  OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED BY '$pass';"
done

user=billingdba
pass=$(openssl rand -base64 32)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED BY '$pass';"
aws ssm put-parameter --name /uc3/mrt/dev/billing/dba/db-password --type SecureString --value "$pass" --overwrite

user=billingrw
pass=$(openssl rand -base64 32)
OPSMODE_PARAM=super /merritt-mysql.sh -e "alter USER '${user}'@'%' IDENTIFIED BY '$pass';"
aws ssm put-parameter --name /uc3/mrt/dev/billing/readwrite/db-password --type SecureString --value "$pass" --overwrite
