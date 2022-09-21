#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev .
# aws ecr create-repository --repository-name mrt-replic
# docker push ${ECR_REGISTRY}/mrt-replic:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-inventory-src:dev as build

WORKDIR /build/mrt-replic

ADD mrt-replic /build/mrt-replic

RUN mvn install -DskipITs -Ddocker.skip && \
    date -r replication-src/target +'mrt-replic: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-replicationwar/1.0-SNAPSHOT/mrt-replicationwar-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM tomcat:8-jre8

RUN apt-get update

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-replicationwar/1.0-SNAPSHOT/mrt-replicationwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/replic.war

RUN mkdir -p /tdr/tmpdir/logs 

EXPOSE 8080 8009

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
