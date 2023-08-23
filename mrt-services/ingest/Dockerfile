#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev .
# aws ecr create-repository --repository-name mrt-ingest
# docker push ${ECR_REGISTRY}/mrt-ingest:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/cdl-zk-queue:dev as build

WORKDIR /build/mrt-ingest

ADD mrt-ingest /build/mrt-ingest

RUN mvn install -Denforcer.skip=true -Dskip.surefire.tests -DskipITs -Ddocker.skip --no-transfer-progress && \
    date -r ingest-src/target +'mrt-ingest: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM public.ecr.aws/docker/library/tomcat:9-jdk11-corretto

# RUN apt-get update -y && apt-get -y upgrade
RUN yum -y update

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ingest.war

EXPOSE 8080 8009

RUN mkdir -p /tdr/ingest/queue && \
    ln -s /tdr/ingest/queue /usr/local/tomcat/webapps/ingestqueue

COPY profiles /tdr/ingest/profiles/
COPY admin-submit /tdr/ingest/admin-submit

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
