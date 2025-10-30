#!/bin/bash

echo "Warning: SDSC and Wasabi credentials are not yet integrated into this script"

ssmval=test_value
# ssmval=$(aws ssm get-parameter --name /uc3/mrt/ecs/merritt-dev/wasabi/access-key-id --query Parameter.Value --output text)
sed -i 's/TEMPLATE_WASABI_ACCESS_KEY_ID/'"$ssmval"'/' /root/.aws/credentials
# ssmval=$(aws ssm get-parameter --name /uc3/mrt/ecs/merritt-dev/wasabi/secret-access-key --query Parameter.Value --output text)
sed -i 's/TEMPLATE_WASABI_SECRET_ACCESS_KEY/'"$ssmval"'/' /root/.aws/credentials
# ssmval=$(aws ssm get-parameter --name /uc3/mrt/ecs/merritt-dev/sdsc/access-key-id --query Parameter.Value --output text)
sed -i 's/TEMPLATE_SDSC_ACCESS_KEY_ID/'"$ssmval"'/' /root/.aws/credentials
# ssmval=$(aws ssm get-parameter --name /uc3/mrt/ecs/merritt-dev/sdsc/secret-access-key --query Parameter.Value --output text)
sed -i 's/TEMPLATE_SDSC_SECRET_ACCESS_KEY/'"$ssmval"'/' /root/.aws/credentials

# ssmval=$(aws ssm get-parameter --name /uc3/mrt/ecs/merritt-dev/sdsc/endpoint-url --query Parameter.Value --output text)
sed -i 's/TEMPLATE_SDSC_ENDPOINT_URL/'"$ssmval"'/' /root/.aws/config
# ssmval=$(aws ssm get-parameter --name /uc3/mrt/ecs/merritt-dev/wasabi/endpoint-url --query Parameter.Value --output text)
sed -i 's/TEMPLATE_WASABI_ENDPOINT_URL/'"$ssmval"'/' /root/.aws/config