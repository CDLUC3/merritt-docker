#!/bin/bash

if [[ -z $SSM_ROOT_PATH ]]; then
  echo "Environment variable SSM_ROOT_PATH only defined for DEV environments"
  exit 1
fi

ssmval=$(aws ssm get-parameter --name ${SSM_ROOT_PATH}cloud/nodes/wasabi-accessKey --query Parameter.Value --output text || echo not_applicable)
sed -i 's/TEMPLATE_WASABI_ACCESS_KEY_ID/'"$ssmval"'/' /root/.aws/credentials
ssmval=$(aws ssm get-parameter --name ${SSM_ROOT_PATH}cloud/nodes/wasabi-secretKey --query Parameter.Value --output text || echo not_applicable)
sed -i 's/TEMPLATE_WASABI_SECRET_ACCESS_KEY/'"$ssmval"'/' /root/.aws/credentials
ssmval=$(aws ssm get-parameter --name ${SSM_ROOT_PATH}cloud/nodes/sdsc-accessKey --query Parameter.Value --output text || echo not_applicable)
sed -i 's/TEMPLATE_SDSC_ACCESS_KEY_ID/'"$ssmval"'/' /root/.aws/credentials
ssmval=$(aws ssm get-parameter --name ${SSM_ROOT_PATH}cloud/nodes/sdsc-secretKey --query Parameter.Value --output text || echo not_applicable)
sed -i 's/TEMPLATE_SDSC_SECRET_ACCESS_KEY/'"$ssmval"'/' /root/.aws/credentials

ssmval=$(aws ssm get-parameter --name ${SSM_ROOT_PATH}cloud/nodes/sdsc-endpoint --query Parameter.Value --output text || echo not_applicable)
sed -i 's/TEMPLATE_SDSC_ENDPOINT_URL/'"$ssmval"'/' /root/.aws/config
ssmval=$(aws ssm get-parameter --name ${SSM_ROOT_PATH}cloud/nodes/wasabi-endpoint --query Parameter.Value --output text || echo not_applicable)
sed -i 's/TEMPLATE_WASABI_ENDPOINT_URL/'"$ssmval"'/' /root/.aws/config