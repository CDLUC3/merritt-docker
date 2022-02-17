# Merritt Docker Images and Orchestration

This library is part of the [Merritt Preservation System](https://github.com/CDLUC3/mrt-doc).

The purpose of this repository is to build docker images for local developer
testing of the [Merritt system](https://github.com/cdluc3/mrt-doc/wiki).

#### Diagram

![](https://github.com/CDLUC3/mrt-doc/raw/main/diagrams/docker.mmd.svg)



## Quick Start Guide

### Installation

Log into one of our uc3-mrt-docker-dev hosts.  Run the following commands as normal user.

1. Ensure user writable directory from which to do initial cloning:
   ```
   cd /dpr2/merritt-workspace
   mkdir $USER
   cd $USER
   ```

1. Clone merritt-docker repo and pull in submodules:
   ```
   $BRANCH=java-refactor.ashley
   git clone git@github.com:CDLUC3/merritt-docker.git -b $BRANCH \
     --remote-submodules --recurse-submodules
   ```

1. Build dependencies:
   ```
   cd merritt-docker
   bin/dep_build.sh
   ```


### Usage

1. Set up docker environment vars:
   ```
   source bin/docker_environment.sh
   ```

1. Run core merritt services:
   ```
   cd mrt-services
   docker-compose build
   docker-compose -p merritt up -d
   docker-compose -p merritt down
   ```

For more detailed usage instructions see [Running Merritt Docker](#Running Merritt Docker) below.



## Overview

UC3 maintains a set of EC2 docker hosts for development use.  See [UC3 Service
Inventory](https://uc3-service-inventory.cdlib.org/index.html?table_name=host&column=fqsn&item=uc3-mrt-docker-dev)


### Security

The IAS team has provisioned these to allow us to run docker commands without
root privileges and to limit access by code running in containers to system
resources on the Docker host.

- UC3 developers are members of group `docker.`
- Docker storage lives under `/dpr2/merritt-workspace.`
- UIDs/GIDs are remapped to prevent container users gaining access
  to privileged resources on Docker hosts.  See:
  [Docker User Namespace Mapping](#Docker User Namespace Mapping) for more info.
- IP addresses for containers are drawn from a custom cidr block to prevent
  overlap with real IPs in the CDL network ("10.10.0.0/16).
- Containers which expose network ports are limited to a set of allowed
  ports (8080:8099).  If we need more ports, we can ask IAS to expand this set.


### Dependencies

The following dependencies are needed to build and run this repo.  The goal is
to build a version of the system that can be run entirely from Docker.

- Docker and Docker Compose install
- Access to the CDL maven repo for a couple of pre-built jars
  - TODO: build these from source in the Dockerfile
- CDL LDAP access
- A local maven repo build of mrt-conf jar files
- Access to storage services
- Access to config properties
  - SSM ParameterStore


### Component Overview

The [mrt-services/docker.html](mrt-services/docker.html) is served by the UI and it provides access to individual containers.

| Component   | Image Name | Where the component runs | Notes |
| ----------- | ---------- | ------------------------ | ----- |
| Zookeeper   | zookeeper | Docker | |
| OpenDJ      | ldap      | Docker | |
| MySQL       | cdluc3/mrt-database | Docker | |
| UI          | cdluc3/mrt-dashboard | Docker | |
| Ingest      | cdluc3/mrt-ingest | Docker | |
| Storage     | cdluc3/mrt-storage | Docker | |
| Inventory   | cdluc3/mrt-inventory | Docker | |
| OAI         | cdluc3/mrt-oai | Docker | Runs with Dryad |
| Sword       | cdluc3/mrt-sword | Docker | Runs with Dryad |
| Dryad UI    | cdluc3/mrt-dryad | Docker | |
| Dryad MySQL | mysql:5.7 | Docker | Populated with Rails Migration Script |
| Dryad SOLR  | cdluc3/dryad-solr | Docker | |
| Audit       | cdluc3/mrt-audit | Docker | No-op by default, runs in audit-replic stack |
| Replic      | cdluc3/mrt-audit | Dockdr | No-op by default, runs in audit-replic stack |
| Merritt Init| cdluc3/mrt-init | Docker | Init OAI and inventory services.  Run Dryad notifier. |
| Apache      | cdluc3/mrt-apache | Docker | Simulates character encoding settings in Merritt Apache |
| Minio       | minio/minio | Docker | Containerized storage service - for testing presigned functionality |
| Minio Cmd   | minio/mc | Docker | Initialized bucket in Minio container |
| ALB Simulator | cdluc3/simulate-lambda-alb | Docker | Simulates an ALB running in front of a Lambda for Collection Admin |
| Collection Admin | ${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/uc3-mrt-colladmin-lambda | Docker | Merritt collection admin tool |
| Opensearch Dashboard |opensearchproject/opensearch-dashboards | Docker | Full ELK stack for indexing and querying container logs. |


### Current Port Usage
- 8080: Ingest
- 8081: Store
- 8082: Inventory
- 8083: OAI
- 8084: Sword
- 8085: Dryad Solr
- 8086: UI
- 8087: Dryad UI
- 8088: Minio
- 8089: CDL Reserved, do not use
- 8090: Lambda Container, Collection Admin
- 8091: ALB Simulator in front of Lambda Container
- 8092: Replic
- 8093: Audit
- 8094: Opensearch Dashboards
- 8095:
- 8096:
- 8097:
- 8098:
- 8099: Apache



### Elastic Container Repository (ECR)

Most docker-compose scripts in this project rely on AWS Elastic Container
Repository (ECR) for publishing and loading custom docker images.  To 
make use of ECR you must set up the following shell enviromnent vars:
```
export AWS_ACCOUNT_ID=`aws sts get-caller-identity| jq -r .Account`
export AWS_REGION=us-west-2
export ECR_REGISTRY=${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com
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

The git submodules for this project are configured in file `.gitmodules`.
Here we specify the repository url, branch and the location (path) where
submodule code will be cloned relative to the root of this project.
If you followed the [Installation](#Installation) instructions at the start
of this README, all submodules will have been pulled into your working tree.

To refresh submodule code from upstream repositories:






## Build and Start Services in VSCode

See [.vscode/settings.json](.vscode/settings.json) for build and stack initiation configurations.

## Build instructions

Services

```bash
cd mrt-services
docker-compose build
```

### Service Start

```bash
docker-compose -p merritt up
```

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

### Service Stop

```bash
docker-compose -p merritt down
```

## Other useful tasks

### List Zookeeper Queues
`docker exec -it zoo zkCli.sh ls /`

### Dump the ingest queue
`docker exec -it zoo listIngest.sh`

### Dump the inventory queue
`docker exec -it zoo listInventory.sh`

### Mysql Session
`docker exec -it db-container mysql -u user --password=password --database=db-name`


## Repo Init

```
git submodule update --remote --recursive --init -- .
git submodule update --remote --recursive -- .
```

## Running Merritt Docker


### Running docker-compose

Set up docker environment vars:
```
source bin/docker_environment.sh
```

Run core merritt services:
```
cd mrt-services
docker-compose build
docker-compose -p merritt up -d
docker-compose -p merritt down
```

Rebuild and run after minor changes to an image:
```
docker-compose -p merritt up -d --build
```

Run Merrit with Dryad:
```
docker-compose -p merritt -f docker-compose.yml -f dryad.yml up -d --build
docker-compose -p merritt -f docker-compose.yml -f dryad.yml down
```

Run Merrit with Opensearch:
```
docker-compose -p merritt -f docker-compose.yml -f opensearch.yml up -d --build
docker-compose -p merritt -f docker-compose.yml -f opensearch.yml down
```


### Helper docker-compose Files

| Goal | File | Comment |
| -- | -- | -- |
| Debug java applications | in Eclipse | Use JPDA Debug on Port 8000 |
|  | in VSCode | Launch a remote debugger [launch.json](launch.json) |
|  | [debug-ingest.yml](mrt-services/debug-ingest.yml) |  |
|  | [debug-inventory.yml](mrt-services/debug-inventory.yml) |
|  | [debug-oai.yml](mrt-services/debug-oai.yml) |
|  | [debug-storage.yml](mrt-services/debug-storage.yml) |
| UI Testing from mrt-dashboard branch | [ui.yml](mrt-services/ui.yml) | Selectively mount code directories from mrt-dashboard to the UI container |
| EC2 Config | [ec2.yml](mrt-services/ec2.yml) | Volume and hostname overrides EC2 dns and paths |
| Localhost Config | [local.yml](mrt-services/local.yml) | hostname |
| Dryad | [dryad.yml](mrt-services/dryad.yml) | Configuration of Dryad services and Merritt services only used by Dryad |
| Dryad Volume Config | [use-volume-dryad.yml](mrt-services/use-volume-dryad.yml) | In addition to the 3 Merritt volumes, persist Dryad mysql and Dryad solr to a Docker volume |
| Audit Replic | [audit-replic.yml](mrt-services/audit-replic.yml) | Configuration of Audit Replic services for Merritt |
| Opensearch Dashboards | [opensearch.yml](mrt-services/opensearch.yml) | Configuration of Full Opensearch stack |
