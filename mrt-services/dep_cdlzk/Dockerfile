#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev .
# aws ecr create-repository --repository-name cdl-zk-queue
# docker push ${ECR_REGISTRY}/cdl-zk-queue:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-core2:dev

WORKDIR /build/cdl-zk-queue

# Now add the java code
ADD cdl-zk-queue ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn -ntp install -DskipTests && \
    date -r target +'dep-cdlzk: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    cp target/*.jar appdir && \
    mvn clean && \
    rm -rf /root/.m2/repository/org/codehaus && \
    rm -rf /root/.m2/repository/org/apache/maven

ENTRYPOINT [ "ls", "appdir" ]