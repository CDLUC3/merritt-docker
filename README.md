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

---

## Older Documentation


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


### Merritt Integration Test Driver

https://github.com/CDLUC3/mrt-integ-tests


### Diagram

```mermaid
%%{init: {'theme': 'neutral', 'securityLevel': 'loose', 'themeVariables': {'fontFamily': 'arial'}}}%%
graph LR
  DOCKYML[[docker-compose.yml]]
  click DOCKYML href "https://github.com/CDLUC3/merritt-docker/blob/main/mrt-services/docker-compose.yml" "source code"
  DOCK(Docker Compose)
  ING([Ingest])
  click ING href "https://github.com/CDLUC3/mrt-ingest" "source code"
  STORE([Storage])
  click STORE href "https://github.com/CDLUC3/mrt-store" "source code"
  UI([Merritt UI])
  click UI href "https://github.com/CDLUC3/mrt-dashboard" "source code"
  INV([Inventory])
  click INV href "https://github.com/CDLUC3/mrt-inventory" "source code"
  ZOO([Zookeeper])
  click ZOO href "https://github.com/CDLUC3/mrt-zoo" "source code"
  LDAP([LDAP])
  click LDAP href "https://github.com/CDLUC3/merritt-docker/tree/main/mrt-services/ldap" "source code"
  MYSQL([MySQL])
  click MYSQL href "https://github.com/CDLUC3/merritt-docker/tree/main/mrt-services/mysql" "source code"
  MINIO([Minio])
  click MINIO href "https://github.com/CDLUC3/merritt-docker/blob/main/mrt-services/docker-compose.yml#L193-L204" "source code"
  MINIOMC([Mino Client])
  click MINIOMC href "https://github.com/CDLUC3/merritt-docker/blob/main/mrt-services/docker-compose.yml#L206-L217" "source code"
  EZID([Mock EZID])
  click EZID href "https://github.com/CDLUC3/merritt-docker/blob/main/mrt-services/docker-compose.yml#L218-L229" "source code"
  INIT([Merritt Docker Init Tasks])
  click INIT href "https://github.com/CDLUC3/merritt-docker/blob/main/mrt-services/docker-compose.yml#L230-L249" "source code"
  COLLADMIN([Merritt Collection Admin])
  click COLLADMIN href "https://github.com/CDLUC3/mrt-admin-lambda" "source code"
  AUDIT([Audit placeholder])
  REPLIC([Replication placeholder])
  SMTP([SMTP])
  click SMTP href "https://github.com/CDLUC3/merritt-docker/blob/main/mrt-services/docker-compose.yml#L165-L170" "source code"
  INPROF[[Ingest Profiles for Docker]]
  click INPROF href "https://github.com/CDLUC3/merritt-docker/tree/main/mrt-services/ingest/profiles" "source code"

  subgraph main
    DOCKYML --> DOCK
    DOCK -.-> ING
    DOCK -.-> STORE
    DOCK -.-> UI
    DOCK -.-> INV
    DOCK -.-> ZOO
    DOCK -.-> LDAP
    DOCK -.-> MYSQL
    DOCK -.-> MINIO
    DOCK -.-> MINIOMC
    DOCK -.-> EZID
    DOCK -.-> INIT
    DOCK -.-> COLLADMIN
    DOCK -.-> AUDIT
    DOCK -.-> REPLIC
    DOCK -.-> SMTP
    INPROF --> ING
  end

  ARYML[[audit-replic.yml]]
  AUDIT2([Audit override])
  REPLIC2([Replication override])
  ARYML --> DOCK

  subgraph audit_replic
    ARYML --> AUDIT2
    ARYML --> REPLIC2
  end

  AUDIT2 -.-> AUDIT
  REPLIC2 -.-> REPLIC
  DRYINIT -.-> INIT

  style DOCK fill:cyan
  style ZOO fill:cyan
  style LDAP fill:cyan
  style MINIO fill:cyan
  style MINIOMC fill:cyan
  style SMTP fill:cyan
  style MINIO fill:#77913C
  style MYSQL fill:#F68D2F
```

---

## UC3 Merritt Docker Hosts

UC3 maintains a set of EC2 docker hosts for development use.  These provide all
the necessary [Docker Dependencies](#docker-dependencies) and compute resources
to run the full fleet of docker containers comprising
[The Merritt Stack](#the-merritt-stack).

For a listing of available merritt docker hosts see
[UC3 Service Inventory](https://uc3-service-inventory.cdlib.org/index.html?table_name=host&column=fqsn&item=uc3-mrt-docker-dev)

The IAS team has provisioned the merritt docker hosts to allow us to run
docker commands without root privileges and to limit access by code running in
containers to system resources on the Docker host.

- UC3 developers are members of group `docker.`
- Docker storage lives under `/dpr2/merritt-workspace.`
- UIDs/GIDs are remapped to prevent container users gaining access
  to privileged resources on Docker hosts.  See:
  [Docker User Namespace Mapping](docs/docker_user_namespace_mapping.md) for more info.
- IP addresses for containers are drawn from a custom cidr block to prevent
  overlap with real IPs in the CDL network ("10.10.0.0/16).
- Containers which expose network ports are limited to a set of allowed
  ports (8080:8099).  If we need more ports, we can ask IAS to expand this set.

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

## Project Internals


### Repository Layout

```
merritt-docker/
├── bin			# helper scripts 
├── docs
├── mrt-integ-tests	# submodule path for running Merritt integrity checks
├── mrt-services	# docker compose scripts and submodule paths for 
|                         dependencies and micro-services
└── README.md
```


### Docker Dependencies

The following dependencies are needed to build and run this repo.  The goal is
to build a version of the system that can be run entirely from Docker.  If you
are running on one of the `uc3-mrt-docker-dev` hosts, these dependencies are
already in place.  In fact, it's probably a waste of effort to try to set 
all this up elsewhere.

- Docker and Docker Compose install
- Access to the CDL maven repo for a couple of pre-built jars
  - TODO: build these from source in the Dockerfile
- CDL LDAP access
- A local maven repo build of mrt-conf jar files
- Access to storage services
- Access to config properties
  - SSM ParameterStore


### Elastic Container Registry

Most docker compose scripts in this project rely on AWS Elastic Container
Registry (ECR) for publishing and loading custom docker images.  To 
make use of ECR you must set up the following shell enviromnent vars:
```
export UC3_ACCOUNT_ID=`get_ssm_value_by_name admintool/uc3account`
export AWS_ACCOUNT_ID=`aws sts get-caller-identity| jq -r .Account`
export AWS_REGION=us-west-2
# export ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
export ECR_REGISTRY=${UC3_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
```

You also must set up docker login credentials with our ECR instance.  This
credential occationally must be renewed from time to time:
```
aws ecr get-login-password --region ${AWS_REGION} | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY}
```


### Git Submodules

This repository uses [git submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
to pull in git repositories for all micro-services and dependencies which will
be used to run a full stack of Merritt Services.

If you followed the [Installation](#installation) instructions at the start
of this README, all submodules will have been pulled into your working tree.

To refresh submodule code from upstream repositories:
```
git submodule update --remote
```

See [Working with Git Submodules](docs/working_with_git_submodules.md) for a detailed tutorial and examples.


---

## Running Merritt Docker

### Cloning Merritt Docker

#### Dev Server Configuration
- Clone merritt-docker to `/apps/dpr2/merritt-workspace/$USER/`
  - [Udpate submodules](#git-submodules)

All `docker-compose` commands require you export shell environment vars.  See
[Elastic Container Registry](#elastic-container-registry) for explanation.  Do
this by sourcing `bin/docker_environment.sh` into your current shell:
```
source bin/docker_environment.sh
```

#### Local Desktop Configuration
- Clone merritt-docker
  - [Udpate submodules](#git-submodules)
- The minio container requires a localhost alias in order to serve up presigned urls.

Consider adding this to your .profile
```
export ECR_REGISTRY=it-docker-registry
```

Make this change once
```
sudo echo '127.0.0.1	my-minio-localhost-alias' >> /etc/hosts
```

### Build Docker Images

Dev Server
```
./bin/dep_build.sh (Out of date)
```

Local Desktop
```
./bin/local_dep_build.sh
```

### Docker Stack Configuration Options
- [Docker Stack Configurations](.vscode/settings.json)

#### Run Core Stack 
Dev Server
_Add --build or --pull as needed_
```
docker compose -p merritt -f mrt-services/docker-compose.yml up -d
```

Local Desktop
_Add --build or --pull as needed_
```
docker compose -p merritt -f mrt-services/docker-compose.yml -f mrt-services/local.yml up -d
```

#### Run Merritt with OpenSearch (see [Using OpenSearch with Merritt Services](docs/using_opensearch.md):
```
docker compose -p merritt -f mrt-services/docker-compose.yml -f mrt-services/local.yml -f mrt-services/opensearch.yml up -d
```

### Maven Builds from merritt-docker
The merritt-docker repo provides a convenient location to build the entrire Merritt system.  This is also a useful way to prepare code for attaching the VSCode debugger to a running Docker stack.

Dev Server
```
./bin/maven_build.sh
```

Local Desktop
```
./bin/local_maven_build.sh
```

Useful Maven Recipes

_All Merritt Services can be built from a grandparent pom file_

```
cd mrt-services
mvn clean
mvn clean install
mvn dependency:analyze
mvn dependency:tree
mvn dependency:build-classpath
```

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


### Other useful tasks

List Zookeeper Queues
```
docker exec -it zoo bash
```

zkCli.sh commands
```
zkCli.sh ls /
zkCli.sh ls /ingest
zkCli.sh ls /mrt.inventory.full
zkCli.sh ls /accessSmall.1
zkCli.sh ls /accessLarge.1
zkCli.sh ls /mrt.lock
```

Mysql Session
```
docker exec -it db-container mysql -u user --password=password --database=db-name
```


