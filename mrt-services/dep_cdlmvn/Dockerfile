#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev .
# aws ecr create-repository --repository-name dep-cdlmvn
# docker push ${ECR_REGISTRY}/dep-cdlmvn:dev

FROM maven:3-jdk-8 as build

WORKDIR /build

# ingest uses
RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=jargs -DartifactId=jargs -Dversion=1.1.1 -Dpackaging=jar \
  -DrepoUrl=https://mvn.cdlib.org/content/repositories/thirdparty/

RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=org.cdlib.mrt -DartifactId=mrt-dataonesrc -Dversion=1.0-SNAPSHOT \
  -Dpackaging=jar -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/

# storage uses this
RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=net.sf -DartifactId=jargs -Dversion=1.0 -Dpackaging=jar \
  -DrepoUrl=https://mvn.cdlib.org/content/repositories/public/

# Used by several repos
RUN mvn dependency:get -Dmaven.legacyLocalRepo=true -DgroupId=org.cdlib.mrt -DartifactId=mrt-jena -Dversion=1.0-SNAPSHOT \
  -Dpackaging=jar -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/