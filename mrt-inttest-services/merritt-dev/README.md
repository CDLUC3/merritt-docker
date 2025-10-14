## Using the `merrritt-dev` container

### Database

```
/merritt-mysql.sh 
/merritt-mysql.sh -e "select 1"
```

### Cloud Storage

```
/merritt-s3.sh ls
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

### Get Hostnames in Service Connect

```
cat /etc/hosts | grep 127
```

### Get My Real IP Address

```
# exlude the compaion fargate and ecs-service-connect containers
curl -s ${ECS_CONTAINER_METADATA_URI_V4}/task | jq '.Containers[] | select(.Name | startswith("aws-") | not) | select(.Name | startswith("ecs-") | not) | .Networks[].PrivateDNSName'
```
