#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev .
# aws ecr create-repository --repository-name mrt-core2
# docker push ${ECR_REGISTRY}/mrt-core2:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/dep-cdlmvn:dev

WORKDIR /build/mrt-core2

# Now add the java code
ADD mrt-core2 ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn install -DskipTests && \
    cp */target/*.jar appdir && \
    mvn clean 

ENTRYPOINT [ "ls", "appdir" ]