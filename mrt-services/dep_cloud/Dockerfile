#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev .
# aws ecr create-repository --repository-name mrt-cloud
# docker push ${ECR_REGISTRY}/mrt-cloud:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-core2:dev

WORKDIR /build/mrt-cloud

# Now add the java code
ADD mrt-cloud ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn install -DskipTests && \
    cp */target/*.jar appdir && \
    mvn clean 

RUN find /root/.m2 -name _remote.repositories | xargs rm 

ENTRYPOINT [ "ls", "appdir" ]