# Using the `merrritt-dev` container

## How to connect

ECS
- `session mrt-ecs-dev-stack/merritt-ops`
- `session mrt-ecs-ephemeral-stack/merritt-ops`
- `session mrt-ecs-dbsnapshot-stack/merritt-ops`
- `session mrt-ecs-stg-stack/merritt-ops`
- `session mrt-ecs-prd-stack/merritt-ops`

Docker compose
- `docker compose exec -it merritt-ops /bin/bash`

## How To

### Connect to Inventory Database

```
/merritt-mysql.sh 
/merritt-mysql.sh -e "select 1"
```

### Connect to Merritt Cloud Storage

- `aws s3 ls`
- `aws s3 ls --profile minio-docker`
- `aws s3 ls --profile minio-ephemeral`
- `aws s3 ls --profile sdsc`
- `aws s3 ls --profile wasabi`

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

## Tools Not in This Image

### ZooKeeper Tools 

#### Connect to ZooKeeper
- `session mrt-ecs-dev-stack/zoo1`
- `docker compose exec -it zoo1 /bin/bash`

#### Tools
- `bin/zkCli.sh`

### LDAP Tools 

#### Connect to LDAP
- `session mrt-ecs-dev-stack/ldap`
- `docker compose exec -it ldap /bin/bash`

#### Useful Tools
- TODO add notes about useful command line tools


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
- [/set-credentails.sh](scripts/set-credentials.sh)
  - pull ssm credentials and modify aws credential files
- [/list-stack-buckets.sh](scripts/list-stack-buckets.sh)
  - pull ssm credentials and modify aws credential files

### As needed
- [/create-audit-error.sh](scripts/create-audit-error.sh)
  - dev stacks only: force a fixity failure in the inv database
- [/create-scan-error.sh](scripts/create-scan-error.sh)
  - dev stacks only: force a storage scan failure in cloud storage
- [/create-scanlist.sh](scripts/create-scanlist.sh)
  - dev stacks only: creates a scanlist for node 7777, saves it as 8888:scanlist/7777.log