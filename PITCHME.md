#### Running Merritt in Docker

https://github.com/terrywbrady/merritt-docker

+++

#### Dependencies for running these containers

https://github.com/terrywbrady/merritt-docker#dependencies

+++

#### Git Submodules

+++?code=.gitmodules&lang=plaintext
@[1-3](Build Dependency - Core2)
@[4-9](Build Dependency - Zookeeper Libs)
@[22-24](Build Dependency - Cloud Library)
@[10-12](Ingest Service has MANY jar dependencies)
@[13-15](Ingest Service)
@[16-18](UI Service)
@[19-21](Storage Service)
@[25-27](Inventory Service)

---

#### Build dependencies

- A base docker image **cdluc3/mrt-dependencies** will be built as a base for other services.
- This image contains a populated maven repo.

+++

#### Build command
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
#### List Jar Files in mrt-dependencies

```
docker run --rm -it cdluc3/mrt-dependencies find /root/.m2 -name "*jar"
```

---

#### Build services

- An image will be built for each service to be run within Docker.
- These services are described and orchestrated with **docker-compose**

+++

#### Build command

```
cd mrt-services
docker-compose build
```

+++?code=mrt-services/docker-compose.yml&lang=yml
@[6-7](Define a container network)
@[9-25](Ingest container)
@[22](localhost:8080/ingest)
@[26-38](Storage container)
@[37](localhost:8081/store)
@[40-51](Insert local credentials at runtime)
@[54-68](Intentory container)
@[65](localhost:8082/inventory)
@[69-81](Zookeeper container)
@[78](localhost:2181)
@[83-98](UI container)
@[94](localhost:9292)
@[102-118](MySQL container)
@[118](localhost:3306)

+++?code=mrt-services/staging-db.yml&lang=yml
@[16](Override compose file to use the staging DB)

---
#### Ingest Service

+++?code=mrt-services/ingest/Dockerfile&lang=dockerfile
@[9-10](Use base image to pre-load jars)
@[12-16](Add code)
@[18-19](Build and install jar)
@[21](Use tomcat base image)
@[22](Install war file)
@[24](Expose tomcat ports)
@[26-27](Create ingestqueue download directory)
@[29-31](Install config files customized for Docker)
@[32](Install demo collection profile)

+++?code=mrt-services/ingest/ingest-info.txt&lang=plaintext
@[7](Link to UI container)
@[10](Link to ingest web server)
+++?code=mrt-services/ingest/queue.txt&lang=plaintext
@[5](Link to Zookeeper container)
+++?code=mrt-services/ingest/stores.txt&lang=plaintext
@[5-6](Link to Storage container)
@[7](Link to Inventory container)
