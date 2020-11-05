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

# There are 2 jar dependencies that are not yet linked as source.
# Pull these from the maven repo.
# We should be able to retire this configuration once the OAI service is deprecated.
COPY settings.xml /root/.m2/

# Mock the system properties that are bundled into Merritt services
# RUN cd mrt-conf-mock && mvn install && mvn clean

# Build jar files
RUN cd mrt-core2 && mvn install -DskipTests && mvn clean
RUN cd cdl-zk-queue && mvn install && mvn clean
RUN cd mrt-zoo && mvn install && mvn clean

# The ingest service includes so many external libraries that it is built here
# The batch-war artifact require errors out when calling git inside of Docker
#  -pl '!batch-war'
RUN cd mrt-ingest && \
    mvn install -D=environment=development  -Denforcer.skip=true -pl '!batch-war' && \
    mvn clean

# Add the cloud services jar file
RUN cd mrt-cloud && mvn install -DskipTests && mvn clean

# Mock the system properties that are bundled into Merritt services - still needed for inventory
RUN cd mrt-conf-mock && mvn install && mvn clean
# OAI and Sword depend on inventory
RUN cd mrt-inventory && mvn install && mvn clean

# We should be able to retire this configuration once the OAI service is deprecated.
ADD http://mvn.cdlib.org/content/groups/public/com/lyncode/xoai-data-provider/4.1.1-SNAPSHOT/xoai-data-provider-4.1.1-SNAPSHOT.jar /tmp
ADD http://mvn.cdlib.org/content/groups/public/com/lyncode/xoai-common/4.1.1-SNAPSHOT/xoai-common-4.1.1-SNAPSHOT.jar /tmp
ADD http://mvn.cdlib.org/content/groups/public/com/lyncode/xoai-data-provider/4.1.1-SNAPSHOT/xoai-data-provider-4.1.1-SNAPSHOT.pom /tmp
ADD http://mvn.cdlib.org/content/groups/public/com/lyncode/xoai-common/4.1.1-SNAPSHOT/xoai-common-4.1.1-SNAPSHOT.pom /tmp
ADD http://mvn.cdlib.org/content/groups/public/com/lyncode/xoai/4.1.1-SNAPSHOT/xoai-4.1.1-SNAPSHOT.pom /tmp

RUN mvn install:install-file -Dfile=/tmp/xoai-data-provider-4.1.1-SNAPSHOT.jar -DgroupId=com.lyncode \
       -DartifactId=xoai-data-provider -Dversion=4.1.1-SNAPSHOT -Dpackaging=jar \
       -DpomFile=/tmp/xoai-data-provider-4.1.1-SNAPSHOT.pom && \
    mvn install:install-file -Dfile=/tmp/xoai-common-4.1.1-SNAPSHOT.jar -DgroupId=com.lyncode \
       -DartifactId=xoai-common -Dversion=4.1.1-SNAPSHOT -Dpackaging=jar \
       -DpomFile=/tmp/xoai-common-4.1.1-SNAPSHOT.pom && \
    mvn install:install-file -Dfile=/tmp/xoai-4.1.1-SNAPSHOT.pom -DgroupId=com.lyncode \
       -DartifactId=xoai -Dversion=4.1.1-SNAPSHOT -Dpackaging=pom

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
