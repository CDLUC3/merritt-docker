#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build -t cdluc3/mrt-zookeeper .

FROM cdluc3/mrt-dependencies as build

FROM zookeeper:3.4

RUN mkdir -p zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/cdl-zk-queue/0.2-SNAPSHOT/cdl-zk-queue-0.2-SNAPSHOT.jar zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-zoopub-src/1.0-SNAPSHOT/mrt-zoopub-src-1.0-SNAPSHOT.jar zkServer/tools

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-core/2.0-SNAPSHOT/mrt-core-2.0-SNAPSHOT.jar zkServer/tools

COPY . zkServer/tools

RUN chmod 555 zkServer/tools/*.sh

ENV ZK=zookeeper-3.4.14
ENV PATH=$PATH:/${ZK}/zkServer/tools

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 2181
