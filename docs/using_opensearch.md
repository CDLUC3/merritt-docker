Using OpenSearch with Merritt Services
======================================

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

- **`opensearch-solo.yml`** - Launches only the three opensearch containers independant of Merritt services. Use for testing and development of opensearch itself.
  ```
  mrt-services> docker-compose -p opensearch -f opensearch-solo.yml up -d
  ```

`opensearch.yml`
: Launch three opensearch containers and add overlay docker log-driver configs to select merritt micro-service containers.



 
