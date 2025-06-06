## Using the `merrritt-dev` container

### Database

```
DBHOST=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/db-host --query Parameter.Value --output text)
DBUSER=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/readwrite/db-user --query Parameter.Value --output text)
DBPASS=$(aws ssm get-parameter --name /uc3/mrt/ecs/billing/readwrite/db-password --query Parameter.Value --with-decryption --output text)
mysql -h $DBHOST -u $DBUSER --password=$DBPASS --database=inv
```

### EFS

```
cd /tdr/ingest/queue
```

### Access Services

```
curl -s http://ui:8086/state.json|jq
curl -s http://store:8080/store/state?t=json|jq
curl -s http://ingest:8080/ingest/state?t=json|jq
```
