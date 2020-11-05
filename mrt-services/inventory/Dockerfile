#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# Publish as cdluc3/mrt-inventory

#   docker build -t cdluc3/mrt-inventory .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-inventory

ADD mrt-inventory /tmp/mrt-inventory

RUN mvn install -D=environment=local && \
    mvn clean

FROM tomcat:8-jre8

#COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-invwar/1.0-SNAPSHOT/mrt-invwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/inventory.war

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-invwar/1.0-SNAPSHOT/mrt-invwar-1.0-SNAPSHOT.war /tmp/inventory.war

RUN mkdir /usr/local/tomcat/webapps/inventory && \
    unzip -d /usr/local/tomcat/webapps/inventory /tmp/inventory.war

RUN mkdir -p /apps/replic/tst/inv/log /tdr/tmpdir

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8080 8009
