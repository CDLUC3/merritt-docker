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

RUN sed -i -e "s/\${ConsumerDaemon}/1/" ingest-war/src/main/webapp/WEB-INF/web.xml

RUN mvn -ntp install -Denforcer.skip=true -Dskip.surefire.tests -DskipITs -Ddocker.skip && \
    date -r ingest-src/target +'mrt-ingest: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM ${ECR_REGISTRY}/merritt-tomcat:dev

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ingest.war

RUN mkdir -p /tdr/ingest/queue && \
    ln -s /tdr/ingest/queue /usr/local/tomcat/webapps/ingestqueue

COPY profiles /tdr/ingest/profiles/
COPY admin-submit /tdr/ingest/admin-submit

