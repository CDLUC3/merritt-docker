#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev .
# aws ecr create-repository --repository-name mrt-zoo
# docker push ${ECR_REGISTRY}/mrt-zoo:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/cdl-zk-queue:dev

WORKDIR /build/mrt-zoo

# Now add the java code
ADD mrt-zoo ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn install -DskipTests && \
    cp */target/*.jar appdir && \
    mvn clean 

RUN find /root/.m2 -name _remote.repositories | xargs rm 

ENTRYPOINT [ "ls", "appdir" ]