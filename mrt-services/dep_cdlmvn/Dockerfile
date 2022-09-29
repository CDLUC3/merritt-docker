#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev .
# aws ecr create-repository --repository-name dep-cdlmvn
# docker push ${ECR_REGISTRY}/dep-cdlmvn:dev

FROM maven:3-jdk-8 as build

RUN apt-get update -y

WORKDIR /build

RUN mkdir -p static

# storage uses this
# RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=net.sf -DartifactId=jargs -Dversion=1.0 -Dpackaging=jar \
#   -DrepoUrl=https://mvn.cdlib.org/content/repositories/public/

# Used by several repos
# RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=org.cdlib.mrt -DartifactId=mrt-jena -Dversion=1.0-SNAPSHOT \
#   -Dpackaging=jar -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/

# for OAI and Sword, mock the conf file creation until those services are migrated to use SSM
WORKDIR /build/mysqlconf

ADD . /build/mysqlconf/

RUN mvn install && \
    date -r target +'dep-cdlmvn: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean