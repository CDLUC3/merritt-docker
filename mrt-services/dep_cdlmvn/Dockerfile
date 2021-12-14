#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev .
# aws ecr create-repository --repository-name dep-cdlmvn
# docker push ${ECR_REGISTRY}/dep-cdlmvn:dev

FROM maven:3.3.1-jdk-8 as build

WORKDIR /build

# RUN mvn dependency:get -DgroupId=org.apache.maven.doxia -DartifactId=doxia-module-markdown -Dversion=1.4 -Dpackaging=jar

COPY settings.xml /root/.m2/

COPY pom.xml .
# RUN mvn dependency:get -Dartifact=org.eclipse.jetty:jetty-xml:11.0.7


# RUN mvn dependency:get -Dartifact=jargs:jargs:1.1.1


# RUN mvn dependency:get -Dartifact=org.apache.maven.doxia:doxia-module-markdown:jar:1.4

RUN mvn dependency:go-offline 

RUN find /root/.m2/repository -name "jargs*"
