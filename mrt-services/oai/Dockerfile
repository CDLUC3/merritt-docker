#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# Publish as cdluc3/mrt-oai

#   docker build -t cdluc3/mrt-oai .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-oai

ADD mrt-oai /tmp/mrt-oai

RUN mvn install -DskipTests && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-oaiwar/1.0-SNAPSHOT/mrt-oaiwar-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/oai.war

EXPOSE 8080 8009
