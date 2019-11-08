# Publish (to a private repo) as cdluc3/mrt-dependencies
# This image will contain an .m2/repository with all Merritt dependencies.
# Merritt service images will be built from this image.

#   docker build -t cdluc3/mrt-dependencies .

FROM maven:3-jdk-8 as build
WORKDIR /tmp

ADD . /tmp
COPY settings.xml /root/.m2/

RUN cd mrt-conf-mock && mvn install && mvn clean
RUN cd mrt-core2 && mvn install -DskipTests && mvn clean
RUN cd cdl-zk-queue && mvn install && mvn clean
RUN cd mrt-zoo && mvn install && mvn clean
# The batch-war artifact require errors out when calling git inside of Docker
#  -pl '!batch-war'
RUN cd mrt-ingest && \
    mvn install -D=environment=development -pl '!batch-war' && \
    mvn clean
RUN cd mrt-cloud && mvn install -DskipTests && mvn clean
