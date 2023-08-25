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

FROM ${ECR_REGISTRY}/merritt-tomcat:dev


COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-invwar/1.0-SNAPSHOT/mrt-invwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/inventory.war

RUN mkdir -p /apps/replic/tst/inv/log /tdr/tmpdir

