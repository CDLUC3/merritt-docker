#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev .
# aws ecr create-repository --repository-name mrt-cloud
# docker push ${ECR_REGISTRY}/mrt-cloud:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-zoo:dev

WORKDIR /build/mrt-cloud

# Now add the java code
ADD mrt-cloud ./

# Build and clean in one step to keep the image size small
RUN mkdir appdir && \
    mvn -ntp install -DskipTests -Ddocker.skip && \
    date -r s3-src/target +'dep-cloud: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    cp */target/*.jar appdir && \
    mvn clean && \
    rm -rf /root/.m2/repository/org/codehaus && \
    rm -rf /root/.m2/repository/org/apache/maven && \
    rm -rf /root/.m2/repository/com/google/cloud/tools && \
    rm -rf /root/.m2/repository/org/yaml/snakeyaml/1.26

ENTRYPOINT [ "ls", "appdir" ]