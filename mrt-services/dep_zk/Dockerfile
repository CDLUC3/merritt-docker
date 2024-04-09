#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zk:dev .
# aws ecr create-repository --repository-name mrt-zk
# docker push ${ECR_REGISTRY}/mrt-zk:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-core2:dev

WORKDIR /build/mrt-zk

# Now add the java code
ADD mrt-zk ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn -ntp install -DskipTests -Ddocker.skip && \
    date -r target +'dep-cdlzk: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    cp target/*.jar appdir && \
    mvn clean && \
    rm -rf /root/.m2/repository/org/codehaus && \
    rm -rf /root/.m2/repository/org/apache/maven

ENTRYPOINT [ "ls", "appdir" ]