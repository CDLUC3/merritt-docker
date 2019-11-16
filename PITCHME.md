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
@[1-2](Use base image to pre-load jars)
@[4-12](Add code)
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
@[1](Use tomcat base image)
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
target: http://localhost:9292
description: UC3 ingest docker micro-service
service-scheme: Ingest/0.1
access-uri: http://ingest:8080
support-uri: http://www.cdlib.org/services/uc3/contact.html
admin:
purl: http://n2t.net/
ezid: merritt:merritt
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
archiveNodeName=nodes-docker-store
archiveNode=7001
```

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

+++

#### UI Auxiliary files
- @gitlink[mrt-services/ui/database.yml.example](mrt-services/ui/database.yml.example])
- @gitlink[mrt-services/ui/mock-app_config.yml](mrt-services/ui/mock-app_config.yml)
- @gitlink[mrt-services/ui/mock-atom.yml](mrt-services/ui/mock-atom.yml)
- @gitlink[mrt-services/ui/mock-ldap.yml](mrt-services/ui/mock-ldap.yml)

---
#### Zookeeper Service

+++

#### @gitlink[mrt-services/zoo/Dockerfile](mrt-services/zoo/Dockerfile)

```dockerfile
FROM cdluc3/mrt-dependencies as build
```

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

+++
#### Merritt Schema Installation
- @gitlink[mrt-services/mysql/init.sql](mrt-services/mysql/init.sql])

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
71d98c0d5fa0        cdluc3/mrt-dashboard   "bundle exec puma -C…"   21 hours ago        Up 21 seconds       3000/tcp, 0.0.0.0:9292->9292/tcp             ui
36c45357390b        cdluc3/mrt-store       "catalina.sh run"        21 hours ago        Up 21 seconds       8009/tcp, 0.0.0.0:8081->8080/tcp             store
2985d892850e        cdluc3/mrt-inventory   "catalina.sh run"        21 hours ago        Up 21 seconds       8009/tcp, 0.0.0.0:8082->8080/tcp             inventory
7e81f87d0872        cdluc3/mrt-database    "docker-entrypoint.s…"   21 hours ago        Up 24 seconds       0.0.0.0:3306->3306/tcp, 33060/tcp            db-container
c5b83fb4d3b9        cdluc3/mrt-zookeeper   "/docker-entrypoint.…"   21 hours ago        Up 24 seconds       2888/tcp, 0.0.0.0:2181->2181/tcp, 3888/tcp   zoo
```
@[2](Ingest on 8080)
@[3](UI on 9292)
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
#### Service Start Using Staging Database

```bash
docker-compose -f docker-compose.yml -f staging-db.yml -p merritt up
```

++++
#### Service Stop Using Staging Database

```
docker-compose -f docker-compose.yml -f staging-db.yml -p merritt down
```

+++

#### List Zookeeper Queues
`docker exec -it zoo zkCli.sh ls /`

+++
#### Dump the ingest queue
`docker exec -it zoo listIngest.sh`

+++
#### Dump the inventory queue
`docker exec -it zoo listInventory.sh`

+++
#### Mysql Session
`docker exec -it db-container mysql -u user --password=password --database=db-name`

---

#### Containerization Next Steps

- Create "disposable" Merritt Storage Node that uses Docker volumes
- Containerize test LDAP service
- Containerize Merritt mail service
- Eliminate dependency on CDL maven store for dependency image
- For pure development testing, eliminate the need for localized config properties

---

#### Additional Ideas

- For storage testing, run docker containers behind the AWS firewall
- Orchestrate Merritt containers with Dryad containers
- Make docker nodes replicable for horizontal scaling

---

#### Want to test it?

- Install Docker desktop
- Clone merritt-docker
- Contact Terry for help setting up local properties
