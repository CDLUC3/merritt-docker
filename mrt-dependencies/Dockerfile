#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# This image will contain an .m2/repository with all Merritt dependencies.
# Merritt service images will be built from this image.

#   docker build -t cdluc3/mrt-dependencies .

FROM maven:3-jdk-8 as build
WORKDIR /tmp

# Add all submodule code to the dockerfile
ADD . /tmp

# Mock the system properties that are bundled into Merritt services
RUN cd mrt-conf-mock && mvn install && mvn clean

# Build jar files
RUN cd mrt-core2 && mvn install -DskipTests && mvn clean
RUN cd cdl-zk-queue && mvn install && mvn clean
RUN cd mrt-zoo && mvn install && mvn clean

# The ingest service includes so many external libraries that it is built here
# The batch-war artifact require errors out when calling git inside of Docker
#  -pl '!batch-war'
RUN cd mrt-ingest && \
    mvn install -D=environment=development -pl '!batch-war' && \
    mvn clean

# Add the cloud services jar file
RUN cd mrt-cloud && mvn install -DskipTests && mvn clean
