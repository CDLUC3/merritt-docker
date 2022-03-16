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



### Logstash Pipeline

 
