#### Running Merritt in Docker

https://github.com/terrywbrady/merritt-docker

+++

#### Dependencies for running these containers

https://github.com/terrywbrady/merritt-docker#dependencies

+++

#### Git Submodules

- @gitlink[.gitmodules](.gitmodules)

+++
#### Build dependency submodules

```ini
[submodule "mrt-dependencies/mrt-core2"]
	path = mrt-dependencies/mrt-core2
	url = https://github.com/cdluc3/mrt-core2
[submodule "mrt-dependencies/cdl-zk-queue"]
	path = mrt-dependencies/cdl-zk-queue
	url = https://github.com/cdluc3/cdl-zk-queue
[submodule "mrt-dependencies/mrt-zoo"]
	path = mrt-dependencies/mrt-zoo
	url = https://github.com/cdluc3/mrt-zoo
[submodule "mrt-dependencies/mrt-ingest"]
	path = mrt-dependencies/mrt-ingest
	url = https://github.com/cdluc3/mrt-ingest
[submodule "mrt-dependencies/mrt-cloud"]
	path = mrt-dependencies/mrt-cloud
	url = https://github.com/CDLUC3/mrt-cloud
```

+++
#### Microservice submodules

```ini
[submodule "mrt-services/ingest/mrt-ingest"]
	path = mrt-services/ingest/mrt-ingest
	url = https://github.com/cdluc3/mrt-ingest
[submodule "mrt-services/ui/mrt-dashboard"]
	path = mrt-services/ui/mrt-dashboard
	url = https://github.com/CDLUC3/mrt-dashboard
[submodule "mrt-services/store/mrt-store"]
	path = mrt-services/store/mrt-store
	url = https://github.com/cdluc3/mrt-store
[submodule "mrt-services/inventory/mrt-inventory"]
	path = mrt-services/inventory/mrt-inventory
	url = https://github.com/CDLUC3/mrt-inventory
```

---

#### Build dependencies

- A base docker image **cdluc3/mrt-dependencies** will be built as a base for other services.
- This image contains a populated maven repo.

+++

#### Build command
```bash
cd mrt-dependencies
docker-compose build
```

+++
#### @gitlink[mrt-dependencies/docker-compose.yml](mrt-dependencies/docker-compose.yml)

```yaml
image: cdluc3/mrt-dependencies
build:
  context: .
  dockerfile: Dockerfile
```

+++
#### @gitlink[mrt-dependencies/Dockerfile](mrt-dependencies/Dockerfile)

+++

#### Create a Maven Docker Image
```dockerfile
FROM maven:3-jdk-8 as build
```

+++

#### Add code to Docker Image
```dockerfile
WORKDIR /tmp

# Add all submodule code to the dockerfile
ADD . /tmp
```

+++

#### Add settings.xml for maven repo
```dockerfile
There are 2 jar dependencies that are not yet linked as source.
# Pull these from the maven repo
COPY settings.xml /root/.m2/
```

+++

#### Build code, install jars
```dockerfile
# Mock the system properties that are bundled into Merritt services
RUN cd mrt-conf-mock && mvn install && mvn clean

# Build jar files
RUN cd mrt-core2 && mvn install -DskipTests && mvn clean
RUN cd cdl-zk-queue && mvn install && mvn clean
RUN cd mrt-zoo && mvn install && mvn clean


# The ingest service includes so many external libraries that it is built here
# The batch-war artifact require errors out when calling git inside of Docker
#  -pl '!batch-war'
RUN cd mrt-ingest && \
    mvn install -D=environment=development -pl '!batch-war' && \
    mvn clean

# Add the cloud services jar file
RUN cd mrt-cloud && mvn install -DskipTests && mvn clean
```

+++
#### List Jar Files in mrt-dependencies

```
docker run --rm -it cdluc3/mrt-dependencies find /root/.m2 -name "*jar"
```

---

#### Build services

- An image will be built for each service to be run within Docker.
- These services are described and orchestrated with **docker-compose**

- @gitlink[mrt-services/docker-compose.yml](mrt-services/docker-compose.yml)

+++

#### Build command

```bash
cd mrt-services
docker-compose build
```

+++

#### Define a container network
```yaml
networks:
  merrittnet:
```

+++

#### Define the Ingest Container
```yaml
ingest:
  container_name: ingest
  depends_on:
  - zoo
  - store
  - inventory
  image: cdluc3/mrt-ingest
  build:
    context: ingest
    dockerfile: Dockerfile
  networks:
    merrittnet:
  ports:
  - published: 8080
    target: 8080
```
@[14](localhost:8080/ingest)

+++

#### Define the Storage Container
```yaml
store:
  container_name: store
  depends_on:
  - zoo
  image: cdluc3/mrt-store
  build:
    context: store
    dockerfile: Dockerfile
  networks:
    merrittnet:
  ports:
  - published: 8081
    target: 8080
```
@[12](localhost:8081/store)

+++

#### Insert Local Credentials at Startup
```yaml
volumes:
- type: bind
  source: ${HOME}/.m2/repository/org/cdlib/mrt/mrt-confs3/1.0-SNAPSHOT/mrt-confs3-1.0-SNAPSHOT.jar
  target: /usr/local/tomcat/webapps/store/WEB-INF/lib/mrt-confs3-1.0-SNAPSHOT.jar
#- type: bind
#  source: ${HOME}/.m2/repository/org/cdlib/mrt/mrt-confstore/test-1.0-SNAPSHOT/mrt-confstore-test-1.0-SNAPSHOT.jar
#  target: /usr/local/tomcat/webapps/store/WEB-INF/lib/mrt-confstore-test-1.0-SNAPSHOT.jar
- type: bind
  source: ./no-track/nodes/repository
  target: /dpr2store/repository
- type: bind
  source: ./no-track/nodes/nodes.txt
  target: /dpr2store/mrtHomes/store/nodes.txt
```

+++

#### Define the Inventory Container
```yaml
inventory:
  container_name: inventory
  depends_on:
  - zoo
  image: cdluc3/mrt-inventory
  build:
    context: inventory
    dockerfile: Dockerfile
  networks:
    merrittnet:
  ports:
  - published: 8082
    target: 8080
  stdin_open: true
  tty: true
```
@[12](localhost:8082/inventory)

+++

#### Define the Zookeeper Container
```yaml
zoo:
  container_name: zoo
  image: cdluc3/mrt-zookeeper
  build:
    context: zoo
    dockerfile: Dockerfile
  networks:
    merrittnet:
  ports:
  - published: 2181
    target: 2181
  stdin_open: true
  tty: true
```
@[10](localhost:2181)

+++

#### Define the UI Container
```yaml
ui:
  container_name: ui
  image: cdluc3/mrt-dashboard
  build:
    context: ui
    dockerfile: Dockerfile
  networks:
    merrittnet:
  depends_on:
  - db-container
  ports:
  - published: 9292
    target: 9292
  volumes:
  # You must install this file with proper credentials
  - ./no-track/ldap-stg.yml:/var/www/app_name/config/ldap.yml
  stdin_open: true
  tty: true
```
@[12](localhost:9292)

+++

#### Define the MySQL Container
```yaml
db-container:
  container_name: db-container
  image: cdluc3/mrt-database
  build:
    context: mysql
    dockerfile: Dockerfile
  networks:
    merrittnet:
  restart: always
  entrypoint: ['docker-entrypoint.sh', '--default-authentication-plugin=mysql_native_password']
  environment:
    MYSQL_DATABASE: 'db-name'
    MYSQL_USER: 'user'
    MYSQL_PASSWORD: 'password'
    MYSQL_ROOT_PASSWORD: 'root-password'
  ports:
    - '3306:3306'
```
@[17](localhost:3306)

+++

### Alternate docker-compose file to use the staging database

- @gitlink[mrt-services/staging-db.yml](mrt-services/staging-db.yml)

+++

```yml
version: '3.7'
networks:
  merrittnet:
services:
  inventory:
    volumes:
    - type: bind
      source: ${HOME}/.m2/repository/org/cdlib/mrt/mrt-confmysql/test-1.0-SNAPSHOT/mrt-confmysql-test-1.0-SNAPSHOT.jar
      target: /usr/local/tomcat/webapps/inventory/WEB-INF/lib/mrt-confmysql-test-1.0-SNAPSHOT.jar
  ui:
    volumes:
    - ./no-track/database-stg.yml:/var/www/app_name/config/database.yml
```

@[12](Override compose file to use the staging DB)

+++

### Run Alterntate docker-compose file

```bash
docker-compose -f docker-compose.yml -f staging-db.yml -p merritt up
```

---
#### Ingest Service

+++

#### @gitlink[mrt-services/ingest/Dockerfile](mrt-services/ingest/Dockerfile)

```dockerfile
FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-ingest

ADD mrt-ingest /tmp/mrt-ingest

# The following dependencies help the service build in Docker
COPY batch-war.pom.xml /tmp/mrt-ingest/batch-war/pom.xml
COPY batch-war.assembly.xml /tmp/mrt-ingest/batch-war/assembly.xml

RUN mvn install -D=environment=local && \
    mvn clean
```

+++

```dockerfile
FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ingest.war

EXPOSE 8080 8009

RUN mkdir -p /tdr/ingest/queue && \
    ln -s /tdr/ingest/queue /usr/local/tomcat/webapps/ingestqueue

COPY ingest-info.txt /tdr/ingest/
COPY queue.txt /tdr/ingest/
COPY stores.txt /tdr/ingest/
COPY profiles /tdr/ingest/profiles/
```


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
