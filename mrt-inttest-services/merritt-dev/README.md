# Using the `merrritt-dev` container

## How to connect

ECS
- `session mrt-ecs-dev-stack/merrittdev`
- `session mrt-ecs-ephemeral-stack/merrittdev`
- `session mrt-ecs-dbsnapshot-stack/merrittdev`
- `session mrt-ecs-stg-stack/merrittdev`
- `session mrt-ecs-prd-stack/merrittdev`

Docker compose
- `docker compose exec -it merrittdev /bin/bash`

## How To

### Connect to Inventory Database

```
/merritt-mysql.sh 
/merritt-mysql.sh -e "select 1"
```

### Connect to Merritt Cloud Storage

```
/merritt-s3.sh ls
/merritt-s3api.sh help
```

### Connect to EFS (if configured for the stack)

```
cd /tdr/ingest/queue
```

### Access Merritt Services (assumes the services have migrated to the stack)

```
curl -s http://ui:8086/state.json|jq
curl -s http://store:8080/store/state?t=json|jq
curl -s http://ingest:8080/ingest/state?t=json|jq
```

### Get Hostnames in Service Connect (ECS)

```
cat /etc/hosts | grep 127
```

### Get My Real IP Address (ECS)

```
# exlude the compaion fargate and ecs-service-connect containers
curl -s ${ECS_CONTAINER_METADATA_URI_V4}/task | jq '.Containers[] | select(.Name | startswith("aws-") | not) | select(.Name | startswith("ecs-") | not) | .Networks[].PrivateDNSName'
```

## Script Inventory

### ECS Task Scripts
- [/start-stack.sh](scripts/start-stack.sh)
  - start a stack of merritt services
- [/stop-stack.sh](scripts/stop-stack.sh)
  - stop a stack of merritt services
- [/redeploy-stack.sh](scripts/redeploy-stack.sh)
  - redeploy a stack of merritt microservices (base services should already be started)
- [/redeploy-zk.sh](scripts/redeploy-zk.sh)
  - controlled redeployment of zookeeper workers in order to preserve the health of the quorum
- [/run-consistency-endpoints.sh](scripts/run-consistency-endpoints.sh)
  - run daily billing database consistency checks
- [/run-unit-test-endpoints.sh](scripts/run-unit-test-endpoints.sh)
  - run the unit tests for the merritt admin tool

### Utility Scripts
- [/merritt-mysql.sh](scripts/merritt-mysql.sh)
  - wrapper for `mysql`
- [/merritt-s3.sh](scripts/merritt-s3.sh)
  - wrapper for `aws s3`
- [/merritt-s3api.sh](scripts/merritt-s3api.sh)
  - untested with minio, used for actions requiring `aws s3api`

### As needed
- [/create-audit-error.sh](scripts/create-audit-error.sh)
  - dev stacks only: force a fixity failure in the inv database
- [/create-scan-error.sh](scripts/create-scan-error.sh)
  - dev stacks only: force a storage scan failure in cloud storage