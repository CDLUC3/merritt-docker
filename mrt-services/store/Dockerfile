#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# Publish as cdluc3/mrt-store

#   docker build -t cdluc3/mrt-store .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-store

ADD mrt-store /tmp/mrt-store

RUN mvn install && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-storewar/1.0-SNAPSHOT/mrt-storewar-1.0-SNAPSHOT.war /tmp/store.war

RUN mkdir /usr/local/tomcat/webapps/store && \
    unzip -d /usr/local/tomcat/webapps/store /tmp/store.war

RUN mkdir -p /dpr2store/mrtHomes/store \
    /dpr2store/mrtHomes/logs \
    /opt/storage/ && \
    touch /opt/storage/test.txt

RUN mkdir -p /usr/local/tomcat/webapps/cloudcontainer/store

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64 -DAccessDaemon=1"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080 8009
