#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

# docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev .
# aws ecr create-repository --repository-name dep-cdlmvn
# docker push ${ECR_REGISTRY}/dep-cdlmvn:dev

FROM maven:3-jdk-8 as build

WORKDIR /build

RUN mvn dependency:get -DgroupId=jargs -DartifactId=jargs -Dversion=1.1.1 -Dpackaging=jar \
  -DrepoUrl=https://mvn.cdlib.org/content/repositories/thirdparty/

RUN mvn dependency:get -DgroupId=jargs -DartifactId=jargs -Dversion=1.1.1 -Dpackaging=pom \
  -DrepoUrl=https://mvn.cdlib.org/content/repositories/thirdparty/

RUN mvn dependency:get -DgroupId=org.cdlib.mrt -DartifactId=mrt-dataonesrc -Dversion=1.0-SNAPSHOT \
  -Dpackaging=jar -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/

RUN mvn dependency:get -DgroupId=org.cdlib.mrt -DartifactId=mrt-dataonesrc -Dversion=1.0-SNAPSHOT \
  -Dpackaging=pom -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/

RUN mvn dependency:get -DgroupId=org.cdlib.mrt -DartifactId=mrt-jena -Dversion=1.0-SNAPSHOT \
  -Dpackaging=jar -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/

RUN mvn dependency:get -DgroupId=org.cdlib.mrt -DartifactId=mrt-jena -Dversion=1.0-SNAPSHOT \
  -Dpackaging=pom -DrepoUrl=https://mvn.cdlib.org/content/repositories/cdl-snapshots/

RUN mvn dependency:get -DgroupId=org.apache.maven.doxia -DartifactId=doxia-module-markdown -Dversion=1.4 -Dpackaging=jar \
  -DrepoUrl=https://repo1.maven.org/maven2/

RUN find /root/.m2 -name _remote.repositories | xargs rm 
