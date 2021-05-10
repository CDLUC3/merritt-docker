# Merritt Docker Images and Orchestration

This library is part of the [Merritt Preservation System](https://github.com/CDLUC3/mrt-doc).

## Purpose
The purpose of this repository is to build docker images for local developer testing of the [Merritt system](https://github.com/cdluc3/mrt-doc/wiki).

## Presentation

![](https://github.com/CDLUC3/mrt-doc/raw/main/diagrams/docker.mmd.svg)

## Dependencies
The following dependencies are needed to build and run this repo.  The goal is to build a version of the system that can be run entirely from Docker.

- Docker and Docker Compose install
- Access to the CDL maven repo for a couple of pre-built jars
  - TODO: build these from source in the Dockerfile
- CDL LDAP access
- A local maven repo build of mrt-conf jar files
- Access to storage services
- Access to config properties
  - Locally stored in **/mrt-services/no-track**

## Component Overview

The [mrt-services/docker.html](mrt-services/docker.html) is served by the UI and it provides access to individual containers.

| Component   | Image Name | Where the component runs | Notes |
| ----------- | ---------- | ------------------------ | ----- |
| Java dependencies | cdluc3/mrt-dependencies | Docker | Base image for other microservices. All service properties are currently mocked in the jar file. |
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
| Collection Admin | cdluc3/uc3-mrt-colladmin-lambda | Docker | Merritt collection admin tool |

## Port usage
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
- 8094:
- 8095:
- 8096:
- 8097:
- 8098:
- 8099: Apache

## Docker Image Publishing
Details about docker image publishing are TBD.

## Git Submodules
This repository uses git submodules to pull in code to be built.

## Credential configuration

Credentials for non-Docker services will be mounted from files within **mrt-services/no-track**.

Files in this directory are not tracked by github.  These dependencies have been almost entirely eliminated due to the SSM refactoring of merritt services.

## Build and Start Services in VSCode

See [.vscode/settings.json](.vscode/settings.json) for build and stack initiation configurations.

## Build instructions

Java Dependencies
```bash
cd mrt-dependencies
docker-compose build
```

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

## Helper docker-compose Files

| Goal | File | Comment |
| -- | -- | -- |
| Debug java applications | in Eclipse | Use JPDA Debug on Port 8000 |
|  | in VSCode | Launch a remote debugger [launch.json](launch.json) |
|  | [debug-ingest.yml](mrt-services/debug-ingest.yml) |  |
|  | [debug-inventory.yml](mrt-services/debug-inventory.yml) |
|  | [debug-oai.yml](mrt-services/debug-oai.yml) |
|  | [debug-storage.yml](mrt-services/debug-storage.yml) |
| UI Testing from mrt-dasboard branch | [ui.yml](mrt-services/ui.yml) | Selectively mount code directories from mrt-dashboard to the UI container |
| EC2 Config | [ec2.yml](mrt-services/ec2.yml) | Volume and hostname overrides EC2 dns and paths |
| Localhost Config | [local.yml](mrt-services/local.yml) | hostname |
| Dryad | [dryad.yml](mrt-services/dryad.yml) | Configuration of Dryad services and Merritt services only used by Dryad |
| Dryad Volume Config | [use-volume-dryad.yml](mrt-services/use-volume-dryad.yml) | In addition to the 3 Merritt volumes, persist Dryad mysql and Dryad solr to a Docker volume |
| Audit Replic | [audit-replic.yml](mrt-services/audit-replic.yml) | Configuration of Audit Replic services for Merritt |

## Repo Init

```
git submodule update --remote --recursive --init -- .
git submodule update --remote --recursive -- .
```

## Common Usage

Localhost run

```
docker-compose -p merritt_a -f docker-compose.yml -f local.yml up -d
```

Localhost run with local ui overrides

```
docker-compose -p merritt_a -f docker-compose.yml -f local.yml -f ui.yml up -d
```

Localhost run with Dryad

```
docker-compose -p merritt_a -f docker-compose.yml -f dryad.yml -f local.yml up -d
```

EC2 run

```
sudo docker-compose -f docker-compose.yml -f ec2.yml -p merritt up -d
```

EC2 run with Dryad
```
udo docker-compose -f docker-compose.yml -f dryad.yml -f ec2.yml -p merritt up -d
```
