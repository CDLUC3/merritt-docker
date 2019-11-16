## Running Merritt in Docker

https://github.com/terrywbrady/merritt-docker

+++

## Dependencies for running these containers

https://github.com/terrywbrady/merritt-docker#dependencies

+++

## Git Submodules

+++?code=.gitmodules&lang=plaintext
@[1-3](Build Dependency - Core2)
@[4-9](Build Dependency - Zookeeper Libs)
@[19-21](Build Dependency - Cloud Library)
@[10-12](Ingest Service has MANY jar dependencies)
@[13-15](Ingest Service)
@[16-18](UI Service)
@[22-24](Storage Service)
@[25-27](Inventory Service)

---

## Build dependencies

A base docker image **cdluc3/mrt-dependencies** will be built as a base for other services.
This image contains a populated maven repo.

```
cd mrt-dependencies
docker-compose build
```

+++?code=mrt-dependencies/docker-compose.yml&lang=yml
@[9](Image Name)
@[10-12](Dockerfile location)

+++?code=mrt-dependencies/Dockerfile&lang=dockerfile
@[11-12](Create a Maven Docker Image)
@[14-15](Add code)
@[17-19](Add settings.xml for maven repo)
@[21-27](Build code, install jars)
@[29-34](Build ingest to install dependent jars)
@[36-37](Build code, install jars)

+++
## List Jar Files in mrt-dependencies

```
docker run --rm -it cdluc3/mrt-dependencies find /root/.m2 -name "*jar"
```

---

## Build services

An image will be built for each service to be run within Docker.

These services are described and orchestrated with **docker-compose**

```
cd mrt-services
docker-compose build
```

+++?code=mrt-services/docker-compose.yml&lang=yml
