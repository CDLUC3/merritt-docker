## This presentation is oboslete

#### Running Merritt in Docker

https://github.com/cdluc3/merritt-docker

+++

#### Why Run Merritt in Docker?

- Create a development environment on-demand |
  - Completely disposable, no servers provisioned
  - Docker is portable: MacOS, Windows, Linux
- Can containerize all dependencies including databases, SOLR, Zookeeper |
  - Run isolated from CDL network (Goal)
- Create an automated test environment on-demand (Goal) |
  - Dispose and re-create as often as needed

+++

#### Docker Concepts
- Docker Image
- Docker Container
- Container Orchestration

+++

#### A Docker Image
- Configured in a Dockerfile |
  - Configuration as code
- Built from a base image |
  - Examples: tomcat, apache, ruby, mysql
- Rebuilt when any configuration change is made |
- Contains the minimal set of dependencies to perform a service |
- Deployed as a Docker Container |

+++

#### A Docker Container
- A running instance of a Docker image |
- Runs within a docker network |
  - Can talk to other containers in that network
- Performs a specific service |
  - Ports and storage can be bound to the host environment
- Destroyed and recreated from the image as needed |
  - Maintain the image, not the container

+++

#### Docker Image Management
- Images can be published to a Container Registry |
- DockerHub is the common location for open source images |
- AWS offers Elastic Container Registry |
  - This will likely be a good choice for Merritt
  - [docker login with AWS credentials](https://aws.amazon.com/blogs/compute/authenticating-amazon-ecr-repositories-for-docker-cli-with-credential-helper/)

+++

#### Container Orchestration
- Connect multiple docker containers to create a system |
  - Example: database container + web server container |
- Define container dependencies |

+++
#### Orchestration Options
  - Docker Compose |
    - Windows, MacOS, Linux
  - Docker Swarm (deprecated) |
  - Kubernetes |
    - Generally offered by a Cloud Provider
    - Some Desktop Tools

+++

#### Basic commands

@ul
- `docker build` creates an image from a dockerfile
- `docker run` creates a container from an image and starts the container
  - `docker stop` stops a running container
  - `docker rm` destroys a stopped container
- `docker exec` runs a command inside a running container
@ulend

+++

#### Container Registry commands
@ul
- `docker login` authenticates to a container registry
- `docker pull` pulls an image from a registry
- `docker push` pushes an image from a registry
@ulend

+++

#### Docker Compose Commands
@ul
- `docker-compose build` performs `docker build` on a collection of interdependent containers
- `docker-compose up` performs `docker run` on a collection of interdependent containers
- `docker-compose down` performs `docker stop` and `docker rm` on a collection of interdependent containers
@ulend

+++

#### Docker Storage Options

- Ephemeral - storage is destroyed when containers are destroyed |
  - This is the default option
- Docker Volumes |
  - Create and dispose interdependent storage volumes with docker commands
- Bind Docker Volumes to "Real" Storage |
  - Mount to local disk with Docker Compose
  - Mount to storage services with Kubernetes

+++

#### Dockerizing Merritt
- Great way to learn the system and the dependencies |
- Create a Dockerfile for each Microservice |
  - Base image is either Tomcat or Ruby
- Create a Dockerfile for other Merritt components |
  - Database
  - Zookeeper
- Assemble components with docker-compose |

+++

#### Presentation Notes
- This presentation dives into each configuration file and explains its purpose |
- Contact Terry |
  - if you would like a detailed overview of those details
  - would like to run this yourself

---  

#### Dependencies for running Merritt containers

- Docker and Docker Compose install |
- Access to the CDL maven repo for a couple of pre-built jars |
  - TODO: build these from source in the Dockerfile
- CDL LDAP access |
- A local maven repo build of mrt-conf jar files |
- Access to config properties |
  - Locally stored in **/mrt-services/no-track**

+++

#### Git Submodules

- Code: https://github.com/cdluc3/merritt-docker  |
- merritt-dependencies |
  - Base docker image (based on Maven) used to build other microservices
- merritt-services |
  - Merritt Microservice code
  - Dryad services can be optionally added

+++
#### Build dependency submodules @gitlink[.gitmodules](.gitmodules)

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
#### Microservice submodules @gitlink[.gitmodules](.gitmodules)

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

+++

#### Git submodule Status

```bash
git submodule status
```

+++

#### Status Output

```plaintext
 9defbdaff6220d6b3ed2368f74bddbc974d524bf mrt-dependencies/cdl-zk-queue (heads/master)
 6112a4dcb4b93970d5ee723b50b9bc025d98c8e9 mrt-dependencies/mrt-cloud (heads/master)
 88f6022e3e622b5aef4fac43be3cc27eedf8f714 mrt-dependencies/mrt-core2 (heads/master)
 082fd890cc74d6aeea03ee84da384d7ad9d6ed94 mrt-dependencies/mrt-ingest (heads/master)
 275773ebcc558c2fab74d30353362b7fb5656d76 mrt-dependencies/mrt-zoo (heads/master)
 082fd890cc74d6aeea03ee84da384d7ad9d6ed94 mrt-services/ingest/mrt-ingest (heads/master)
 a74d942521a25a6edc0897b2d60a87a4800a4d90 mrt-services/inventory/mrt-inventory (PT164702206-4-ga74d942)
 7cd33facd0ed1c758996734c79e8a32a15cf1bed mrt-services/store/mrt-store (heads/master)
 fb4f92c00e68e5a3af93846959a4aeda1df8f222 mrt-services/ui/mrt-dashboard (2019.2-1-gfb4f92c0)
```
@[9](FYI: This repo has been modified)

+++

#### Updating a git submodule
```bash
git submodule update --remote mrt-services/ui/mrt-dashboard
```

+++

#### Submodule Update
```plaintext
remote: Enumerating objects: 7, done.
remote: Counting objects: 100% (7/7), done.
remote: Compressing objects: 100% (4/4), done.
remote: Total 47 (delta 3), reused 3 (delta 3), pack-reused 40
Unpacking objects: 100% (47/47), done.
From https://github.com/CDLUC3/mrt-dashboard
   fb4f92c0..15f32156  master                           -> origin/master
 * [new branch]        dependabot/bundler/loofah-2.3.1  -> origin/dependabot/bundler/loofah-2.3.1
 * [new branch]        dependabot/bundler/rubyzip-1.3.0 -> origin/dependabot/bundler/rubyzip-1.3.0
 * [new branch]        issue-167_email_recipients       -> origin/issue-167_email_recipients
Submodule path 'mrt-services/ui/mrt-dashboard': checked out '15f32156d04cd0c03b20a5ce4bd6f47b8bf3234d'
```

+++

#### Submodule update status

```bash
git submodule status
```

+++

#### Status Output

```plaintext
 9defbdaff6220d6b3ed2368f74bddbc974d524bf mrt-dependencies/cdl-zk-queue (heads/master)
 6112a4dcb4b93970d5ee723b50b9bc025d98c8e9 mrt-dependencies/mrt-cloud (heads/master)
 88f6022e3e622b5aef4fac43be3cc27eedf8f714 mrt-dependencies/mrt-core2 (heads/master)
 082fd890cc74d6aeea03ee84da384d7ad9d6ed94 mrt-dependencies/mrt-ingest (heads/master)
 275773ebcc558c2fab74d30353362b7fb5656d76 mrt-dependencies/mrt-zoo (heads/master)
 082fd890cc74d6aeea03ee84da384d7ad9d6ed94 mrt-services/ingest/mrt-ingest (heads/master)
 a74d942521a25a6edc0897b2d60a87a4800a4d90 mrt-services/inventory/mrt-inventory (PT164702206-4-ga74d942)
 7cd33facd0ed1c758996734c79e8a32a15cf1bed mrt-services/store/mrt-store (heads/master)
+15f32156d04cd0c03b20a5ce4bd6f47b8bf3234d mrt-services/ui/mrt-dashboard (2019.2-15-g15f32156)
```
@[9](Notice the modification - new commit hash is in place)

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
@[1-2](Build mock property files)
@[4-7](Build core and zookeeper jars)
@[9-14](Install ingest dependencies)
@[16-17](Build cloud library)

+++
#### List Jar Files in mrt-dependencies

- The mrt-dependencies image is not intended to be run, it will be the base image for other services.  
- The following command will display the jar files built into the image.

```bash
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
  volumes:
  - type: bind
    source: ./no-track/ingest-info.txt
    target: /tdr/ingest/ingest-info.txt
```
@[14](localhost:8080/ingest)
@[16-19](supply runtime values to ingest service)
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

#### Insert Storage Config/Credentials at Startup
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
  - published: 8086
    target: 9292
  volumes:
  # You must install this file with proper credentials
  - ./no-track/ldap-stg.yml:/var/www/app_name/config/ldap.yml
  stdin_open: true
  tty: true
```
@[12](localhost:8086)

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
    - published: 3306
      target: 3306
```
@[17](localhost:3306)

+++

#### Define the SMTP container
```yaml
smtp:
  container_name: smtp
  image: namshi/smtp
  networks:
    merrittnet:
  #ports:
  #- published: 25
  #  target: 25
```

+++

#### Define the Merritt Init Container
```yaml
merritt-init:
  container_name: merritt-init
  image: cdluc3/mrt-init
  depends_on:
  - inventory
  build:
    context: merritt-init
    dockerfile: Dockerfile
  networks:
    merrittnet:
  entrypoint:
    - /bin/bash
    - '-c'
    - |
        echo "*** Pause 30 seconds then init the inventory service"
        sleep 30
        echo "*** Starting the inventory service"
        curl -X POST http://inventory:8080/inventory/service/start?t=json
        echo "*** Service Init Complete"
        sleep 5000
```
@[12-14](Run bash script)
@[15-16](Wait 30 seconds to allow services to start)
@[18](POST to inventory service to start processing)
@[20](Sleep for a long time)

---

### Additional docker-compose file to start Dryad Services

- @gitlink[mrt-services/dryad.yml](mrt-services/dryad.yml)

+++

### Run Alterntate docker-compose file

```bash
docker-compose -f docker-compose.yml -f dryad.yml -p merritt up
```

+++

#### OAI Service
```yaml
oai:
  container_name: oai
  image: cdluc3/mrt-oai
  build:
    context: oai
    dockerfile: Dockerfile
  networks:
    merrittnet:
  ports:
  - published: 8083
    target: 8080
  stdin_open: true
  tty: true
```

+++

#### Sword Service
```yaml
sword:
  container_name: sword
  image: cdluc3/mrt-sword
  build:
    context: sword
    dockerfile: Dockerfile
  networks:
    merrittnet:
  ports:
  - published: 8084
    target: 8080
  stdin_open: true
  tty: true
  volumes:
  - type: bind
    source: ./no-track/sword-info.txt
    target: /apps/replic/tst/sword/mrtHomes/sword/sword-info.txt
```

+++

#### Dryad UI Service
```yaml
dryad:
  container_name: dryad
  image: cdluc3/dryad
  build:
    context: dryad
    dockerfile: Dockerfile
  networks:
    merrittnet:
  volumes:
  - type: bind
    source: ./no-track/dryad/app_config.yml
    target: /var/www/app_name/config/app_config.yml
  - type: bind
    source: ./no-track/dryad/tenants/dryad.yml
    target: /var/www/app_name/config/tenants/dryad.yml
  ports:
  - published: 3000
    target: 3000
```

+++

#### Dryad MySQL Service
```yaml
dryad-db:
  container_name: dryad-db
  image: mysql:5.7
  networks:
    merrittnet:
  restart: always
  entrypoint: ['docker-entrypoint.sh', '--default-authentication-plugin=mysql_native_password']
  environment:
    MYSQL_DATABASE: 'dryad'
    MYSQL_USER: 'user'
    MYSQL_PASSWORD: 'password'
    MYSQL_ROOT_PASSWORD: 'root-password'
  ports:
  - published: 3307
    target: 3306
```

+++

#### Dryad SOLR Service
```yaml
solr:
  container_name: solr
  image: cdluc3/dryad-solr
  build:
    context: dryad-solr
    dockerfile: Dockerfile
  networks:
    merrittnet:
  restart: always
  ports:
  - published: 8983
    target: 8983
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
@[1-2](Use base image to pre-load jars)
@[4-8](Add code)
@[10-11](Build and install jar)

+++

#### Dockerfile Step 2

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
@[1](The service will run as a tomcat service)
@[2](Install war file)
@[4](Expose tomcat ports)
@[6-7](Create ingestqueue download directory)
@[9-11](Install config files customized for Docker)
@[12](Install demo collection profile)

+++

#### @gitlink[mrt-services/ingest/ingest-info.txt](mrt-services/ingest/ingest-info.txt)

```ini
name: UC3 Docker Ingest
identifier: ingest
target: http://localhost:8086
description: UC3 ingest docker micro-service
service-scheme: Ingest/0.1
access-uri: http://ingest:8080
support-uri: http://www.cdlib.org/services/uc3/contact.html
admin:
purl: http://n2t.net/
ezid: example:value
```
@[3](Link to UI container)
@[6](Link to ingest web server)

+++

#### @gitlink[mrt-services/ingest/queue.txt](mrt-services/ingest/queue.txt)
```ini
QueueService: zoo:2181
QueueName: /ingest
InventoryName: /mrt.inventory.full
QueueHoldFile: /tdr/ingest/queue/HOLD
PollingInterval: 10
NumThreads: 5
```
@[1](Link to Zookeeper container)
+++

#### @gitlink[mrt-services/ingest/stores.txt](mrt-services/ingest/stores.txt)
```ini
store.1: http://store:8080/store
access.1: http://store:8080/store
localID: http://inventory:8080/inventory
```
@[1-2](Link to Storage container)
@[3](Link to Inventory container)

---
#### Inventory Service

+++

#### @gitlink[mrt-services/inventory/Dockerfile](mrt-services/inventory/Dockerfile)

```dockerfile
FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-inventory

ADD mrt-inventory /tmp/mrt-inventory

RUN mvn install -D=environment=local && \
    mvn clean
```
@[1](Use base image for build)
@[2-4](Install code)
@[6-7](Build and install war file)

+++
#### Dockerfile Step 2

```dockerfile
FROM tomcat:8-jre8

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-invwar/1.0-SNAPSHOT/mrt-invwar-1.0-SNAPSHOT.war /tmp/inventory.war

RUN mkdir /usr/local/tomcat/webapps/inventory && \
    unzip -d /usr/local/tomcat/webapps/inventory /tmp/inventory.war

RUN mkdir -p /apps/replic/tst/inv/log /tdr/tmpdir

COPY inv-info.txt /apps/replic/tst/inv/

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64"

EXPOSE 8080 8009
```
@[1](The service will run as a tomcat service)
@[3-6](Unzip and install war file)
@[8-10](Install a mock inventory config file)
@[12](Allow url encoded ark's to be part of a path name)
@[14](Expose tomcat ports)

+++
#### @gitlink[mrt-services/inventory/inv-info.txt](mrt-services/inventory/inv-info.txt)
```ini
serviceScheme: Inv/1.0
name: UC3
identifier: inventory
description: UC3 storage micro-service docker
baseURI: http://localhost:8082/inventory
storageURI: http://store:8080/store

#Zookeeper
zooPollMilli=60000
ZooThreadCount: 5
QueueName: /mrt.inventory.full
PollingInterval: 10
QueueService: zoo:2181
```
@[5](Public URL for the inventory service)
@[6](Storage service)
@[11](Inventory queue name)
@[13](Zookeeper service)

---
#### Storage Service

+++

#### @gitlink[mrt-services/store/Dockerfile](mrt-services/store/Dockerfile)

```dockerfile
FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-store

ADD mrt-store /tmp/mrt-store

RUN mvn install -D=environment=local && \
    mvn clean
```
@[1](Use base image for build)
@[2-4](Install code)
@[6-7](Build and install war file)

+++
#### Dockerfile Step 2

```dockerfile
FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-storewar/1.0-SNAPSHOT/mrt-storewar-1.0-SNAPSHOT.war /tmp/store.war

RUN mkdir /usr/local/tomcat/webapps/store && \
    unzip -d /usr/local/tomcat/webapps/store /tmp/store.war

RUN mkdir -p /dpr2store/mrtHomes/store /dpr2store/

COPY store-info.txt /dpr2store/mrtHomes/store

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64"

EXPOSE 8080 8009
```
@[1](The service will run as a tomcat service)
@[2-5](Unzip and install war file)
@[7-9](Install a mock storage config file)
@[11](Allow url encoded ark's to be part of a path name)
@[13](Expose tomcat ports)

+++
#### @gitlink[mrt-services/store/store-info.txt](mrt-services/store/store-info.txt)
```ini
serviceScheme: Store/1.0
name: UC3-stg-docker
identifier: localhost:8081
description: UC3 storage micro-service
supportURI: mailto:no-email@ucop.edu
baseURI: http://localhost:8081/store
producerFilter.1=mrt-erc.txt
producerFilter.2=mrt-eml.txt
producerFilter.3=mrt-dc.txt
producerFilter.4=mrt-delete.txt
producerFilter.5=mrt-dua.txt
producerFilter.6=mrt-dataone-manifest.txt
producerFilter.7=mrt-datacite.xml
producerFilter.8=mrt-oaidc.xml
producerFilter.9=stash-wrapper.xml
# The following will be used for cloud storage for async download
# nodes io table.  Override this at runtime.
archiveNodeName=
archiveNode=
```
@[3](Public host for storage service)
@[6](Public url for the storage service)
@[16-19](Cloud container node for large object (async) downloads)
---
#### UI Service

+++

#### @gitlink[mrt-services/ui/Dockerfile](mrt-services/ui/Dockerfile)

```dockerfile
FROM ruby:2.4.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/app_name
RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='test'
ENV RACK_ENV='test'
```
@[1-2](Configure ruby image)

+++
#### Dockerfile continued

```dockerfile
# Adding gems
COPY mrt-dashboard/Gemfile Gemfile
COPY mrt-dashboard/Gemfile.lock Gemfile.lock

RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY mrt-dashboard .
COPY mock-ldap.yml config/ldap.yml
COPY mock-atom.yml config/atom.yml
COPY database.yml.example config/database.yml
COPY mock-app_config.yml config/app_config.yml

RUN bundle exec rake assets:precompile
EXPOSE 3000 9292
CMD ["bundle", "exec", "puma", "-C", "config/application.rb"]
```
@[1-3](Add gem files)
@[5-6](Install gems)
@[8](Install code)
@[9-12](Install mock config files)
@[14](Build code)
@[15](Expose web server port)
@[16](Run puma)

+++

#### UI Auxiliary files
- @gitlink[mrt-services/ui/database.yml.example](mrt-services/ui/database.yml.example])
- @gitlink[mrt-services/ui/mock-app_config.yml](mrt-services/ui/mock-app_config.yml)
- @gitlink[mrt-services/ui/mock-atom.yml](mrt-services/ui/mock-atom.yml)
- @gitlink[mrt-services/ui/mock-ldap.yml](mrt-services/ui/mock-ldap.yml)

+++

#### @gitlink[mrt-services/ui/mock-app_config.yml](mrt-services/ui/mock-app_config.yml])
```yml
test:
  <<: *development
  max_archive_size:     536870912  # 536870912 bytes = 512 MiB
  max_download_size:    5368709120  # 5368709120 bytes = 5 GiB
  uri_1: "http://store:8080/store/content/"
  uri_2: "http://store:8080/store/producer/"
  ingest_service:       "http://ingest:8080/ingest/poster/submit/"
  ingest_service_update: "http://ingest:8080/ingest/poster/update/"
  #large object download url
  container_url:        "http://localhost:8081/container/"
```
@[5-6](Storage Service URL)
@[7-8](Ingest Service URL)
@[9-10](Large Object Async Download URL)

---
#### Zookeeper Service

+++

#### @gitlink[mrt-services/zoo/Dockerfile](mrt-services/zoo/Dockerfile)

```dockerfile
FROM cdluc3/mrt-dependencies as build
```
@[1](Make Merritt code available to image)

+++
#### Dockerfile Step 2

```dockerfile
FROM zookeeper:3.4

RUN mkdir -p zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/cdl-zk-queue/0.2-SNAPSHOT/cdl-zk-queue-0.2-SNAPSHOT.jar zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-zoopub-src/1.0-SNAPSHOT/mrt-zoopub-src-1.0-SNAPSHOT.jar zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-core/2.0-SNAPSHOT/mrt-core-2.0-SNAPSHOT.jar zkServer/tools

COPY . zkServer/tools

RUN chmod 555 zkServer/tools/*.sh

ENV ZK=zookeeper-3.4.14
ENV PATH=$PATH:/${ZK}/zkServer/tools

EXPOSE 2181
```
@[1](Standard Zookeeper image)
@[3-16](Add Merritt Queue display code to tools dir)
@[18](Expose Zookeeper port)

+++

#### Merritt Queue Reader Script
- @gitlink[mrt-services/zoo/listQueue.sh](mrt-services/zoo/listQueue.sh])

---
#### MySQL Service

+++

#### @gitlink[mrt-services/mysql/Dockerfile](mrt-services/mysql/Dockerfile)

```dockerfile
FROM mysql:5.7

COPY init.sql /docker-entrypoint-initdb.d/start.sql

EXPOSE 3306 33060
```
@[1](Standard MySQL image)
@[3](Install dump of Merritt database schema - runs after container creation)
@[5](Expose MySQL port)

+++
#### Merritt Schema Installation
- @gitlink[mrt-services/mysql/init.sql](mrt-services/mysql/init.sql])

---
#### Merritt Init Service

+++

#### @gitlink[mrt-services/merritt-init/Dockerfile](mrt-services/merritt-init/Dockerfile)

```dockerfile
FROM ubuntu

# Add curl to image
RUN apt-get update && apt-get install -y curl
```
@[4](Add curl to base image)

---

#### Dryad Service Configuration

- @gitlink[mrt-services/dryad.yml](mrt-services/dryad.yml)
- This work is in progress

---

#### Docker Commands

+++

#### Build Dependencies
```bash
cd mrt-dependencies
docker-compose build
```

+++

#### Build Services
```bash
cd mrt-services
docker-compose build
```

+++

#### Service Commands

Run these commands from the mrt-services directory.

+++

#### Service Start

```bash
docker-compose -p merritt up
```

+++

#### Verify running processes and ports
```bash
docker ps -a
```

+++

#### Process Output

```plaintext
CONTAINER ID        IMAGE                  COMMAND                  CREATED             STATUS              PORTS                                        NAMES
e972f92c7913        cdluc3/mrt-ingest      "catalina.sh run"        21 hours ago        Up 19 seconds       8009/tcp, 0.0.0.0:8080->8080/tcp             ingest
71d98c0d5fa0        cdluc3/mrt-dashboard   "bundle exec puma -C…"   21 hours ago        Up 21 seconds       3000/tcp, 0.0.0.0:8086->9292/tcp             ui
36c45357390b        cdluc3/mrt-store       "catalina.sh run"        21 hours ago        Up 21 seconds       8009/tcp, 0.0.0.0:8081->8080/tcp             store
2985d892850e        cdluc3/mrt-inventory   "catalina.sh run"        21 hours ago        Up 21 seconds       8009/tcp, 0.0.0.0:8082->8080/tcp             inventory
7e81f87d0872        cdluc3/mrt-database    "docker-entrypoint.s…"   21 hours ago        Up 24 seconds       0.0.0.0:3306->3306/tcp, 33060/tcp            db-container
c5b83fb4d3b9        cdluc3/mrt-zookeeper   "/docker-entrypoint.…"   21 hours ago        Up 24 seconds       2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   zoo
```
@[2](Ingest on 8080)
@[3](UI on 8086)
@[4](Storage on 8081)
@[5](Inventory on 8082)
@[6](MySQL on 3306)
@[7](Zookeeper on 2181)

+++

#### View logs for a specific container
```bash
docker logs ingest
```

+++

#### Tail logs for a specific container
```bash
docker logs -f inventory
```

+++

#### List docker networks
```bash
docker network ls
```

+++
#### Service Stop

```bash
docker-compose -p merritt down
```

+++
#### Service Start Including Dryad

```bash
docker-compose -f docker-compose.yml -f dyrad.yml -p merritt up
```

+++
#### Service Stop (Including Dryad)

```bash
docker-compose -f docker-compose.yml -f dryad.yml -p merritt down
```

+++

#### List Zookeeper Queues
```bash
docker exec -it zoo zkCli.sh ls /
```

+++
#### Dump the ingest queue
```bash
docker exec -it zoo listIngest.sh
```

+++
#### Dump the inventory queue
```bash
docker exec -it zoo listInventory.sh
```

+++
#### Mysql Session
```bash
docker exec -it db-container mysql -u user --password=password --database=db-name
```

---

#### Useful URL's

Service | URL
------- | ---
UI | http://localhost:8086
Ingest | http://localhost:8080/ingest/state/
Storage | http://localhost:8081/store/state
Inventory | http://localhost:8082/inventory/state

+++

#### Dryad URL's

Service | URL
------- | ---
Dryad UI | http://localhost:3000
OAI | http://localhost:8083/oai/oai/v2?verb=Identify
Sword | http://localhost:8084/sword/collection/cdl_dryaddev
SOLR | http://localhost:8983

---

#### Containerization Next Steps

- Containerize test LDAP service |
- Eliminate dependency on CDL maven store for dependency image |
- For pure development testing, eliminate the need for localized config properties |

---

#### Additional Ideas

- Run docker containers behind the AWS firewall |
  - For storage testing
  - For more compute power for testing
- Create automated test suites that create/destroy docker containers |
- Orchestrate Merritt containers with Dryad containers |
- Make docker images replicable for horizontal scaling |
- Kubernetes orchestration |

---

#### Want to test it?

- Install Docker desktop
- Clone merritt-docker
- Contact Terry for help setting up local properties
