#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev .
# aws ecr create-repository --repository-name mrt-ingest
# docker push ${ECR_REGISTRY}/mrt-ingest:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-zoo:dev as build

WORKDIR /build/mrt-ingest

ADD mrt-ingest /build/mrt-ingest

# The following dependencies help the service build in Docker
COPY batch-war.pom.xml /build/mrt-ingest/ingest-war/pom.xml
COPY batch-war.assembly.xml /build/mrt-ingest/ingest-war/assembly.xml

RUN mvn install -Denforcer.skip=true && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ingest.war

EXPOSE 8080 8009

RUN mkdir -p /tdr/ingest/queue && \
    ln -s /tdr/ingest/queue /usr/local/tomcat/webapps/ingestqueue

COPY profiles /tdr/ingest/profiles/
COPY admin-submit /tdr/ingest/admin-submit

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
