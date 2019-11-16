#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# Publish as cdluc3/mrt-ingest

#   docker build -t cdluc3/mrt-ingest .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-ingest

ADD mrt-ingest /tmp/mrt-ingest
COPY batch-war.pom.xml /tmp/mrt-ingest/batch-war/pom.xml
COPY batch-war.assembly.xml /tmp/mrt-ingest/batch-war/assembly.xml

RUN mvn install -D=environment=local && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ingest.war

EXPOSE 8080 8009

RUN mkdir -p /tdr/ingest/queue && \
    ln -s /tdr/ingest/queue /usr/local/tomcat/webapps/ingestqueue

COPY ingest-info.txt /tdr/ingest/
COPY queue.txt /tdr/ingest/
COPY stores.txt /tdr/ingest/
COPY profiles /tdr/ingest/profiles/
