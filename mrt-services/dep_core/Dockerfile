#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev .
# aws ecr create-repository --repository-name mrt-core2
# docker push ${ECR_REGISTRY}/mrt-core2:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/merritt-maven:dev

WORKDIR /build/mrt-core2

# Now add the java code
ADD mrt-core2 ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn -ntp install -Pparent && \
    mvn -ntp install -DskipTests && \
    date -r core/target +'dep-core: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    cp */target/*.jar appdir && \
    mvn clean && \
    rm -rf /root/.m2/repository/org/codehaus

ENTRYPOINT [ "ls", "appdir" ]