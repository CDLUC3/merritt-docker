#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build -t ${ECR_REGISTRY}/mrt-core2:dev .
# aws ecr create-repository --repository-name mrt-core2
# docker push ${ECR_REGISTRY}/mrt-core2:dev

FROM maven:3-jdk-8 as build

WORKDIR /build/mrt-core2

# Now add the java code
ADD mrt-core2 ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn install -DskipTests && \
    cp */target/*.jar appdir && \
    mvn clean 

ENTRYPOINT [ "ls", "appdir" ]