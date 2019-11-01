# Publish (to a private repo) as cdluc3/mrt-dependencies
# This image will contain an .m2/repository with all Merritt dependencies.
# Merritt service images will be built from this image.

#   docker build -t cdluc3/mrt-dependencies .

FROM maven:3-jdk-8 as build
WORKDIR /tmp

ADD . /tmp

RUN cd mrt-conf-mock && mvn install && mvn clean
RUN cd mrt-core2 && mvn install -DskipTests && mvn clean
RUN cd cdl-zk-queue && mvn install && mvn clean
RUN cd mrt-zoo && mvn install && mvn clean
RUN cd mrt-ingest && mvn install -pl '!batch-war' -D=environment=development && mvn clean
