#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev .
# aws ecr create-repository --repository-name dep-cdlmvn
# docker push ${ECR_REGISTRY}/dep-cdlmvn:dev

FROM maven:3.9-eclipse-temurin-8-alpine as build

#RUN apt-get update -y && apt-get -y upgrade

WORKDIR /build

RUN mkdir -p static

WORKDIR /build/mysqlconf

ADD . /build/mysqlconf/

RUN mvn install && \
    date -r target +'dep-cdlmvn: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean