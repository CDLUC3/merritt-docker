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

RUN mvn install -DskipITs -Ddocker.skip --no-transfer-progress && \
    date -r store2-src/target +'mrt-store: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-storewar/1.0-SNAPSHOT/mrt-storewar-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM ${ECR_REGISTRY}/merritt-tomcat:dev


COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-storewar/1.0-SNAPSHOT/mrt-storewar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/store.war

RUN mkdir -p /dpr2store/mrtHomes/store \
    /dpr2store/mrtHomes/logs \
    /opt/storage/ && \
    touch /opt/storage/test.txt
RUN mkdir -p /usr/local/tomcat/webapps/cloudcontainer/store

