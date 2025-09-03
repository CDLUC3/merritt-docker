Merritt Docker Images and Orchestration
---

This library is part of the [Merritt Preservation System](https://github.com/CDLUC3/mrt-doc).

The purpose of this repository is to build docker images for local developer
testing of the [Merritt system](https://github.com/cdluc3/mrt-doc/wiki).

## Deployment Options

### UC3 Docker Dev Server
- You must me a member of group `docker`.
- Clone this repo under `/dpr2/merritt-workspace/$USER`
  - A large file system has been created for this purpose 

### Local Workstation
- M2 Macbook Pro (16G RAM) or equivalent
- Docker Desktop installed
  - Allocate 10G of RAM for Docker Desktop 

## Clone the repo
Log into one of our uc3-mrt-docker-dev hosts.  Run the following commands as normal user.

Clone merritt-docker repo and pull in submodules:

```bash
BRANCH=main git clone git@github.com:CDLUC3/merritt-docker.git -b $BRANCH \
  --remote-submodules --recurse-submodules
```

### Local Workstation

Allow Minio container to resolve local pre-signed URL's
```bash
sudo echo '127.0.0.1	my-minio-localhost-alias' >> /etc/hosts
```

## Code Repo Synchronization

Ensure all submodule code is up-to-date with respective remotes:
```bash
git submodule update --remote
```

## ECR Login

Login to AWS
```bash
aws sso login
```


It is recommended that you save this to a script named `~/bin/devops.sh`
```bash
export AWS_ACCOUNT_ID=$(aws sts get-caller-identity)
export UC3_ACCOUNT_ID=$(aws ssm get-parameter --name /uc3/mrt/dev/admintool/uc3account --query Parameter.Value --output text)
export CODEARTIFACT_URL=https://cdlib-uc3-mrt-${UC3_ACCOUNT_ID}.d.codeartifact.us-west-2.amazonaws.com/maven/uc3-mrt-java/
export AWS_REGION=us-west-2
export ECR_REGISTRY=${UC3_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com

export CODEARTIFACT_AUTH_TOKEN=`aws codeartifact get-authorization-token --domain cdlib-uc3-mrt --domain-owner $UC3_ACCOUNT_ID --region $AWS_REGION --query authorizationToken --output text`
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin ${ECR_REGISTRY}
```

## Stack Creation

```bash
cd mrt-services
# this pulls the latest docker images from ECR, these are build daily in CodeBuild
docker compose pull
docker compose up -d
```

## Use Port Fowarding to access the stack in a browser
- 8086: opens the UI
- 8099: opens the Admin Tool

## Access the Merritt Dev container to access all services

```bash
bash-5.2$ docker compose exec merrittdev /bin/bash
root@1ed17e89ce16:/# curl http://store:8080/store/state?t=json|jq
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   380  100   380    0     0    213      0  0:00:01  0:00:01 --:--:--   213
{
  "sto:storageServiceState": {
    "sto:nodeStates": {
      "sto:nodeState": [
        "http://uc3-mrtdocker-dev01.cdlib.org:8081/store/state/7777",
        "http://uc3-mrtdocker-dev01.cdlib.org:8081/store/state/8888"
      ]
    },
    "sto:failNodes": "",
    "sto:failNodesCnt": 0,
    "xmlns:sto": "http://uc3.cdlib.org/ontology/mrt/store/storage",
    "sto:logRootLevel": "INFO",
    "sto:baseURI": "http://uc3-mrtdocker-dev01.cdlib.org:8081/store"
  }
}
```

## Database Access

```bash
docker compose exec merrittdev /merritt-mysql.sh
mysql: [Warning] Using a password on the command line interface can be insecure.
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 43
Server version: 8.0.41-0ubuntu0.22.04.1 (Ubuntu)

Copyright (c) 2000, 2025, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

## Cloud Access

```bash
 docker compose exec merrittdev /bin/bash
root@fd1f9ead7479:/# AWS_ACCESS_KEY_ID=minioadmin AWS_SECRET_ACCESS_KEY=minioadmin aws s3 --endpoint-url http://minio:8088 ls
1-01-01 00:00:00    mrt-config
1-01-01 00:00:00    my-bucket
1-01-01 00:00:00    my-bucket-repl
root@fd1f9ead7479:/#
```

## View Logs

```bash
docker compse logs store
```

## Shutdown the Stack (preserve content)
```bash
docker compose down
```

## Shutdown the Stack and destroy all content
```bash
docker compose down --volumes
```

## Maven Build Tips

Set Merritt Maven Vars
```bash
cd mrt-services
mvn -ntp -Pparent clean deploy
mvn clean deploy -f reflect/pom.xml
```

Build Merritt (with tests)
```bash
cd mrt-services
mvn -ntp clean install 
```

Build Merritt (without tests)
```bash
cd mrt-services
mvn install -Ddocker.skip -DskipITs -Dmaven.test.skip=true
```

## Rebuild a Merritt Service, Restart

```bash
cd mrt-services
docker compose build store
docker compose up -d
```

## Pull a Merritt Service from ECR

```bash
cd mrt-services
docker compose pull store
docker compose up -d
```

---

## Older Documentation

---

## Component Overview

### The Merritt Stack

Custom built docker images are staged in our AWS [Elastic Container
Registry](#elastic-container-registry) instance.  This is notated below as ${ECR}.

The [mrt-services/docker.html](mrt-services/docker.html) is served by the UI
and it provides access to individual containers.


| Component        | Image Name                      | Notes |
| -----------      | ----------                      | ----- |
| Zookeeper        | zookeeper                       |       |
| OpenDJ           | ldap                            |       |
| MySQL            | ${ECR}/mrt-database             |       |
| UI               | ${ECR}/mrt-dashboard            |       |
| Ingest           | ${ECR}/mrt-ingest               |       |
| Storage          | ${ECR}/mrt-storage              |       |
| Inventory        | ${ECR}/mrt-inventory            |       |
| Audit            | ${ECR}/mrt-audit                |       |
| Replic           | ${ECR}/mrt-replic                |       |
| Merritt Init     | ${ECR}/mrt-init                 | Init inventory services.|
| Minio            | minio/minio                     | Containerized storage service - for testing presigned functionality |
| Minio Cmd        | minio/mc                        | Initialized bucket in Minio container |

### Optional OpenSearch Stack

see [Using OpenSearch with Merritt Services](docs/using_opensearch.md)

| Component            | Image Name            | Notes |
| -----------          | ----------            | ----- |
| OpenSearch           | opensearchproject/opensearch            | |
| OpenSearch Dashboard | opensearchproject/opensearch-dashboards | |
| Logstash             | opensearchproject/logstash-oss          | |



---

## UC3 Merritt Docker Hosts

  **Current Port Usage**
  | Port | Category | Purpose |
  | ---- | -------- | ------- |
  | 8080 | Dev Stack| Ingest|
  | 8080 | IntTest Stack| Integration Test: service-it tomcat port|
  | 8081 | Dev Stack| Store|
  | 8082 | Dev Stack| Inventory|
  | 8086 | Dev Stack| UI|
  | 8088 | Dev Stack| Minio API|
  | 8089 | `***` | CDL Reserved, do not use|
  | 8092 | Dev Stack| Replic|
  | 8093 | Dev Stack| Audit|
  | 8094 | OpenSearch Stack| OpenSearch Dashboards|
  | 8095 | Dev Stack| Minio Web Console|
  | 8096 | IntTest Stack| Integration Test: Mock Merritt Service|
  | 8097 | OpenSearch Stack| OpenSearch API|
  | 8098 | IntTest Stack| Integration Test: Minio admin port|
  | 8098 | Dev Stack| Ingest Callback |
  | 8099 | Admin Tool| Integration Test: service-it debug|

### Helper docker compose Files

| Goal                     | File                                                      | Comment |
| --                       | --                                                        | -- |
| Debug java applications  | in Eclipse                                                | Use JPDA Debug on Port 8000 |
|                          | in VSCode                                                 | Launch a remote debugger [launch.json](launch.json) |
|                          | [debug-ingest.yml](mrt-services/debug-ingest.yml)         |
|                          | [debug-inventory.yml](mrt-services/debug-inventory.yml)   |
|                          | [debug-storage.yml](mrt-services/debug-storage.yml)       |
|                          | [debug-audit.yml](mrt-services/debug-audit.yml)       |
|                          | [debug-replic.yml](mrt-services/debug-replic.yml)       |
|                          | [debug-oai.yml](mrt-services/debug-oai.yml)               |
| UI Testing               | [ui.yml](mrt-services/ui.yml)                             | Selectively mount code directories from mrt-dashboard to the UI container |
| OpenSearch Dashboards    | [opensearch.yml](mrt-services/opensearch.yml)             | Configuration of Full OpenSearch stack |




## Build and Start Services in VSCode

See [.vscode/settings.json](.vscode/settings.json) for build and stack initiation configurations.

---



## Useful Docker Tips and Commands

### Docker Basics

To verify running processes and ports
```bash
docker ps -a
```

To view persistent volumes
```bash
docker volume ls
```

To view logs for a specific container
```bash
docker logs ingest
```

Tail view logs for a specific container
```bash
docker logs -f inventory
```

To view the docker network
```bash
docker network ls
```
