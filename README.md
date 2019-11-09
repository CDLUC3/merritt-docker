# merritt-docker

## Purpose
The purpose of this repository is to build docker images for local developer testing of the [Merritt system](https://github.com/cdluc3/mrt-doc/wiki).

## Dependencies
The following dependencies are needed to build and run this repo.  The goal is to build a version of the system that can be run entirely from Docker.

- Access to the CDL maven repo.
- CDL LDAP access
- A local maven repo build of mrt-conf jar files
- CDL LDAP access
- CDL Inventory DB access

## Component Overview

| Component | Image Name | Where the component runs | Notes |
| --------- | ---------- | ------------------------ | ----- |
| Java dependencies | cdluc3/mrt-dependencies | Docker | Base image for other microservices. All service properties are currently mocked in the jar file. |
| Zookeeper | zookeeper | Docker | |
| MySQL     | cdluc3/mrt-database | Docker or Server Instance | |
| LDAP      | N/A | Server Instance | |
| UI        | cdluc3/mrt-dashboard | Docker | Database and LDAP connection info is passed in via an untracked file |
| Ingest    | cdluc3/mrt-ingest | Docker | |
| Storage    | cdluc3/mrt-storage | Docker | |
| Inventory    | cdluc3/mrt-inventory | Docker | |

## Docker Image Publishing
Details about docker image publishing are TBD.

## Git Submodules
This repository uses git submodules to pull in code to be built.

**TBD**: document submodule update process

## Credential configuration

Credentials for non-Docker services will be mounted from files within **mrt-services/no-track**.

Files in this directory are not tracked by github.

## Build instructions

Java Dependencies
```
cd mrt-dependencies
docker-compose build
```

Services

```
cd mrt-services
docker-compose build
```

## Service Configuration Options
| Config Name | LDAP | DB | Storage Node | Note |
| ------------- | ------ | -- | --------------- | ---- |
|Docker DB - Staging Storage | Staging | Docker | Staging - single node recommended by David | In Progress |
|Staging DB & Storage | Staging | Staging | Staging - single node recommended by David | In Progress |
|Docker DB - Isolated Storage | Staging | Docker | Isolated storage node that is distinct from Staging | TBD |
|Isolation| Docker | Docker | Isolated storage node that is distinct from Staging | TBD, create standalone or mock LDAP |


## Docker DB - Staging Storage

### Service Start

```
docker-compose -p merritt up
```

To verify running processes and ports
```
docker ps -a
```

To view persistent volumes
```
docker volume ls
```

To view the docker network
```
docker network ls
```

### Service Stop

```
docker-compose -p merritt down
```

## Staging DB & Storage

### Service Start

```
docker-compose -f docker-compose.yml -f staging-db.yml -p merritt up
```

To verify running processes and ports
```
docker ps -a
```

### Service Stop

```
docker-compose -f docker-compose.yml -f staging-db.yml -p merritt down
```
