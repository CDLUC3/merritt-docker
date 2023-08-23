#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev .
# aws ecr create-repository --repository-name mrt-inventory
# docker push ${ECR_REGISTRY}/mrt-inventory:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-cloud:dev as build

WORKDIR /build/mrt-inventory

ADD mrt-inventory /build/mrt-inventory

RUN mvn install -D=environment=local -DskipITs -Ddocker.skip --no-transfer-progress && \
    date -r inv-src/target +'mrt-inv: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-invwar/1.0-SNAPSHOT/mrt-invwar-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM public.ecr.aws/docker/library/tomcat:9-jdk11-corretto

# RUN apt-get update -y && apt-get -y upgrade
RUN yum -y update

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-invwar/1.0-SNAPSHOT/mrt-invwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/inventory.war

RUN mkdir -p /apps/replic/tst/inv/log /tdr/tmpdir

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080 8009
