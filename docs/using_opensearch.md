Using OpenSearch with Merritt Services
======================================

**Note** - This environment is intended only for development.


## Quick Start

### Launch OpenSearch stack together with Merritt services:

```
mrt-services> docker-compose -p merritt -f docker-compose.yml -f opensearch.yml up -d --build
mrt-services> docker-compose -p merritt -f docker-compose.yml -f opensearch.yml down
```


### Access OpenSearch Dashboards UI

Point your browser to http://_my-docker-hosts_:8094

Login as `admin`. Ask a teammate for the password.

In top left corner is a small box with horizontal lines.  This opens a dropdown menu.

Select **Discover** to start building log queries. 

You should see the `logstash*` index pattern pre-populated. 

For further instruction see [Documentation for OpenSearch Dashboards](https://opensearch.org/docs/latest/dashboards/index/).



---


## The OpenSearch Stack

### Containers

The OpenSearch Stack consists of three docker containers:

| Container             | Function |
| ---------             | -------- |
| opensearch            | OpenSearch log analytics engine     |
| opensearch-dashboards | The OpenSearch UI (formerly Kibana) |
| logstash              | Filter and stream docker container logs into opensearch |

Indexed log data and UI configurations are persisted by volume mount
(`opensearch-data1`) on the docker host.

Dockerfiles and build resources for each of these containers is are located under
`mrt-services/opensearch`:

```
merritt-docker/mrt-services/opensearch
├── logstash
│   ├── Dockerfile
│   ├── logstash.conf
├── opensearch
│   └── Dockerfile
└── opensearch-dashboards
    ├── Dockerfile
    └── opensearch_dashboards.yml
```



### Docker Compose

There are two docker-compose files for launching an OpenSearch stack.  These live under `mrt-services/:

- **`opensearch.yml`**
  Launch three opensearch containers and add overlay docker log-driver configs to select merritt micro-service containers.

- **`opensearch-solo.yml`**
  Launches only the three opensearch containers independant of Merritt services. Use for testing and development of opensearch itself.
  ```
  mrt-services> docker-compose -p opensearch -f opensearch-solo.yml up -d
  ```


---


## Indexing log events

Docker containers emit log events to standard output. 

These are forwarded by the docker log driver to the Logstash instance for
filtering and index configuration.  

Logstash outputs filtered log streams to the opensearch instance for indexing.

```
log event
    └── stdout
        └── docker log-driver
            └── logstash
                └── opensearch data node
```


### Redirecting log events to stdout

Currently, most Merritt micro-services write application logs to local files.
However, for log events from docker containers to be indexed they must be written to
standard output.  This will also be required when services are hosted in AWS
AutoScaling Groups or Elastic Container Service (ECS).  

#### Refactoring application loggers

See example config in https://github.com/CDLUC3/mrt-doc-private/blob/main/docs/poc/log4j-ecs-layout_setup.md

#### Redirecting Tomcat access logs to STDOUT

To redirect access logs to stdout, we must manage a modified `server.xml` file in docker:
```
merritt-docker/mrt-services/store> merritt-docker/mrt-services/store> diff server.xml.dist server.xml
163,164c163,164
<         <Valve className="org.apache.catalina.valves.AccessLogValve" directory="logs"
<                prefix="localhost_access_log" suffix=".txt"
---
>         <Valve className="org.apache.catalina.valves.AccessLogValve" directory="/dev/stdout"
>                prefix="" suffix="" rotatable="false"
```

```
diff --git a/mrt-services/store/Dockerfile b/mrt-services/store/Dockerfile
index 42be47d..fdaf6d8 100644
--- a/mrt-services/store/Dockerfile
+++ b/mrt-services/store/Dockerfile
@@ -20,6 +20,7 @@ RUN mvn install && \
 
 FROM tomcat:8-jre8
 COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-storewar/1.0-SNAPSHOT/mrt-storewar-1.0-SNAPSHOT.war /build/store.war
+COPY server.xml /usr/local/tomcat/conf/server.xml
 
 RUN mkdir /usr/local/tomcat/webapps/store && \
```


### GELF Log-driver

We use the [Graylog Extended Format logging
driver](https://docs.docker.com/config/containers/logging/gelf/) to stream
docker container logs to our logstash instance.  It is possible to configure
`gelf` options globally in `/etc/docker/deamon.yaml` so that all containers
forward logs to logstash.  But this would be too noisey, and the logstash
container may not be running at any given time.

Instead we set per-container gelf log-driver configs only for select merritt
micro-service containers.  These settings reside in the `opensearch.yml` docker
compose file.  In this way, gelf logging options are only defined when the
opensearch stack is launched.

The logstash container listens to port `12201/udp`. 

```
merritt-docker> tail -38 mrt-services/opensearch.yml 

  # Overlay logging configs to merritt containers
  #
  apache:
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
  ingest:
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
  store:
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
  inventory:
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
  ui:
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
  replic:
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
  audit:
    logging:
      driver: gelf
      options:
        gelf-address: "udp://localhost:12201"
```


### Logstash Pipeline

We build the logstash docker container with a custom `logstash.conf` file:
```
merritt-docker> cat mrt-services/opensearch/logstash/Dockerfile 
FROM opensearchproject/logstash-oss-with-opensearch-output-plugin:7.16.3
COPY logstash.conf /usr/share/logstash/pipeline/logstash.conf
USER root
``` 

This file has three sections defining rules for inputs, filtering, and outputs.
```
merritt-docker> cat mrt-services/opensearch/logstash/logstash.conf
# docker gelf log-driver -> Logstash -> OpenSearch

input {
  # Listen for logstreams from GELF docker log-driver
  gelf {
    type => docker
    port =>  12201
  }
}

filter {
  # parse tomcat access log for ECS compatibility
  grok {
    ecs_compatibility => v1
    match => {"message" => "%{HTTPD_COMMONLOG}" }
  }
}

output {
  # post filtered logstreams to OpenSearch 
  opensearch {
    hosts => ["https://opensearch:9200"]
    user => "admin"
    password => "admin"
    ssl_certificate_verification => false
  }
}
```


### Setting the Index Pattern in OpenSearch-Dashboards UI

The first time the OpenSearch docker stack is run we need to configure an
**index pattern** in the OpenSearch-Dashboards UI.  This required for running
searches and building queries in the UI.

From the dropdown menu (in top left corner) select
**Stack Management** -> **Index Patterns**.

Create a sinlge index pattern - `logstash*`.  This pattern will match all
indexes coming from logstash.  Once configured, this setting will persist, as
it is stored as metadata in the OpenSearch container's data volume.


