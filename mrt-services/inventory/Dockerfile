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

RUN mkdir -p /apps/replic/tst/inv /tdr/tmpdir /apps/dpr2/mrtHomes/inv

COPY inv-info.txt /apps/replic/tst/inv/
COPY inv-info.txt /apps/dpr2/mrtHomes/inv

EXPOSE 8080 8009