# Need to investigate why login time can be so high
MS_LOGIN=60000
MS_RESP=4000
DURATION=2m

if [[ "$MERRITT_ECS" == "ecs-prd" ]]
then
  MERRITTURL=https://merritt.cdlib.org
  SSMPATH=/uc3/mrt/dev/integ-tests/for-prod
  USERCOUNT=6
  ARKLIST=ark:/99999/fk4t16pn3j,ark:/99999/fk4xp8q22b
else
  MERRITTURL=https://merritt-stage.cdlib.org
  SSMPATH=/uc3/mrt/dev/integ-tests/for-stage
  USERCOUNT=6
  MS_RESP=5000
  # stage arks are purged weekly
  ARKLIST=
fi

if [[ "$LOCUST_MODE" == "readonly" ]]
then
  export MNEMONIC=merritt_demo_pub
  export TESTARKS=
else
  export MERRITTUSER=$(aws ssm get-parameter --name ${SSMPATH}/user --query Parameter.Value --output text)
  export MERRITTPASS=$(aws ssm get-parameter --name ${SSMPATH}/password --with-decryption --query Parameter.Value --output text)
  export MNEMONIC=merritt_demo
  export TESTARKS=$ARKLIST
fi

if [[ "$LOCUST_MODE" == "long" ]]
then
  USERCOUNT=$((USERCOUNT * 3))
  DURATION=10m
fi