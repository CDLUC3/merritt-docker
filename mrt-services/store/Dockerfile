# Publish as cdluc3/mrt-store

#   docker build -t cdluc3/mrt-store .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-store

ADD mrt-store /tmp/mrt-store

RUN mvn install -D=environment=local && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-storewar/1.0-SNAPSHOT/mrt-storewar-1.0-SNAPSHOT.war /tmp/store.war

RUN mkdir /usr/local/tomcat/webapps/store && \
    unzip -d /usr/local/tomcat/webapps/store /tmp/store.war

RUN mkdir -p /dpr2store/mrtHomes/store /dpr2store/

COPY store-info.txt /dpr2store/mrtHomes/store

EXPOSE 8080 8009
