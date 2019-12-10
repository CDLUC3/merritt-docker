#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# Publish as cdluc3/mrt-sword

#   docker build -t cdluc3/mrt-sword .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-sword

ADD mrt-sword /tmp/mrt-sword

RUN mvn install && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-swordwarpub/1.0-SNAPSHOT/mrt-swordwarpub-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/sword.war

EXPOSE 8080 8009
