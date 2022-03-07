#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev .
# aws ecr create-repository --repository-name mrt-store
# docker push ${ECR_REGISTRY}/mrt-store:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-cloud:dev as build

WORKDIR /build/mrt-store

ADD mrt-store /build/mrt-store

RUN mvn install && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-storewar/1.0-SNAPSHOT/mrt-storewar-1.0-SNAPSHOT.war /build/store.war
COPY server.xml /usr/local/tomcat/conf/server.xml

RUN mkdir /usr/local/tomcat/webapps/store && \
    unzip -d /usr/local/tomcat/webapps/store /build/store.war

RUN mkdir -p /dpr2store/mrtHomes/store \
    /dpr2store/mrtHomes/logs \
    /opt/storage/ && \
    touch /opt/storage/test.txt
RUN mkdir -p /usr/local/tomcat/webapps/cloudcontainer/store

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64 -DAccessDaemon=1"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
#ENV TOMCAT_LOGLEVEL=debug
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080 8009
