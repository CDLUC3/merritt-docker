#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-zoo:dev as build

FROM zookeeper

RUN apt-get update -y

RUN mkdir -p zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/cdl-zk-queue/0.2-SNAPSHOT/cdl-zk-queue-0.2-SNAPSHOT.jar zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-zoopub-src/1.0-SNAPSHOT/mrt-zoopub-src-1.0-SNAPSHOT.jar zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-core/2.0-SNAPSHOT/mrt-core-2.0-SNAPSHOT.jar zkServer/tools

COPY --from=build /root/.m2/repository/log4j/log4j/1.2.17/log4j-1.2.17.jar lib

COPY --from=build /root/.m2/repository/org/slf4j/slf4j-log4j12/1.7.25/slf4j-log4j12-1.7.25.jar lib

COPY --from=build /root/.m2/repository/org/slf4j/slf4j-api/1.7.25/slf4j-api-1.7.25.jar lib

COPY . zkServer/tools

RUN chmod 555 zkServer/tools/*.sh

ENV ZK=apache-zookeeper-3.8.0-bin
ENV ZKJ=zookeeper-3.8.0
ENV ZKJUTE=zookeeper-jute-3.8.0
ENV PATH=$PATH:/${ZK}/zkServer/tools

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 2181
