#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-oai:dev .
# aws ecr create-repository --repository-name mrt-oai
# docker push ${ECR_REGISTRY}/mrt-oai:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-inventory-src:dev as build

RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=com.lyncode -DartifactId=xoai-data-provider -Dversion=4.1.1-SNAPSHOT \
  -Dpackaging=jar -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/ 

RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=com.lyncode -DartifactId=xoai-common -Dversion=4.1.1-SNAPSHOT \
  -Dpackaging=jar -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/ 

WORKDIR /build/mrt-oai

ADD mrt-oai /build/mrt-oai

RUN mvn install -DskipTests && \
    date -r oai-src/target +'mrt-oai: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-oaiwar/1.0-SNAPSHOT/mrt-oaiwar-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM tomcat:8-jre8

RUN apt-get update

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-oaiwar/1.0-SNAPSHOT/mrt-oaiwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/oai.war

EXPOSE 8080 8009

RUN mkdir -p /apps/replic/stg/oai/mrtHomes/oai/log/ /apps/replic/stg/oai/mrtHomes/oai

# COPY oai-info.txt /replic/mrtHomes/oai
COPY oai-info.txt /apps/replic/stg/oai/mrtHomes/oai

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
