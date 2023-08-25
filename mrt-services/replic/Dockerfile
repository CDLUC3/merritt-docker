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

RUN mvn install -DskipITs -Ddocker.skip --no-transfer-progress && \
    date -r replication-src/target +'mrt-replic: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-replicationwar/1.0-SNAPSHOT/mrt-replicationwar-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM ${ECR_REGISTRY}/merritt-tomcat:dev


COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-replicationwar/1.0-SNAPSHOT/mrt-replicationwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/replic.war

RUN mkdir -p /tdr/tmpdir/logs 

