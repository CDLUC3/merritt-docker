#! /bin/bash

header() {
  svc=$1
  echo "================"
  echo "  Service: $svc"
  echo "================"
}

echo "LDAP Status as of $(TZ='America/Los_Angeles' date)" > /var/www/html/ldap.txt

export ECS_STACK_NAME=mrt-${MERRITT_ECS}-stack

for svc in ldap ldapreplica
do
  header $svc >> /var/www/html/ldap.txt
  ldap=$(aws ecs list-tasks --cluster $ECS_STACK_NAME --service-name $svc --query taskArns --output text)

  unbuffer aws ecs execute-command --cluster $ECS_STACK_NAME --task $ldap \
    --container $svc --command "/opt/opendj/merritt-status.sh" --interactive >> /var/www/html/ldap.txt
done

aws s3 cp /var/www/html/ldap.txt "s3://${S3REPORT_BUCKET}/ldap/status.txt"
