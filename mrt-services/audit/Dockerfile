#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************
# Publish as cdluc3/mrt-replic

#   docker build -t cdluc3/mrt-replic .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-audit

ADD mrt-audit /tmp/mrt-audit

RUN mvn install && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-auditwarpub/1.0-SNAPSHOT/mrt-auditwarpub-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/audit.war

RUN mkdir -p /tdr/tmpdir/logs 

EXPOSE 8080 8009

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC -d64"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
