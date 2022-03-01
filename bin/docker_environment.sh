# Setup docker env vars
#
export AWS_ACCOUNT_ID=`aws sts get-caller-identity| jq -r .Account`
export AWS_REGION=us-west-2
export ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk
export PATH=$JAVA_HOME/bin:$HOME/bin:$PATH
export RAILS_ENV=test


