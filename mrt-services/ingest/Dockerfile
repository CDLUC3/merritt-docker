# Publish as cdluc3/mrt-ingest

#   docker build -t cdluc3/mrt-ingest .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-ingest

ADD mrt-ingest /tmp/mrt-ingest

RUN mvn install -D=environment=local && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-ingestwar/1.0-SNAPSHOT/mrt-ingestwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ingest.war

EXPOSE 8080 8009

RUN mkdir -p /tdr/ingest /usr/local/tomcat/webapps/ingestqueue

COPY ingest-info.txt /tdr/ingest/
COPY queue.txt /tdr/ingest/
COPY storage.txt /tdr/ingest/
