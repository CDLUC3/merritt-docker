# merritt-docker

The purpose of this repository is to build docker images for local developer testing of the [Merritt system](https://github.com/cdluc3/mrt-doc/wiki).

| Component | Image Name | Where the component runs | Notes |
| --------- | ---------- | ------------------------ | ----- |
| Java dependencies | cdluc3/mrt-dependencies | Docker | Base image for other microservices. All service properties are currently mocked in the jar file. |
| Zookeeper | zookeeper | Docker | |
| MySQL     | cdluc3/mrt-database | Docker or Server Instance | |
| LDAP      | N/A | Server Instance | |
| UI        | cdluc3/mrt-dashboard | Docker | Database and LDAP connection info is passed in via an untracked file |
| Ingest    | cdluc3/mrt-ingest | Docker | |

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

## Service Startup

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

## Service Stop

```
docker-compose -p merritt down
```
