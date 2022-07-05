#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-sword:dev .
# aws ecr create-repository --repository-name mrt-sword
# docker push ${ECR_REGISTRY}/mrt-sword:dev

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mrt-inventory-src:dev as build

WORKDIR /build/mrt-sword

ADD mrt-sword /build/mrt-sword

RUN mvn install && \
    date -r sword-src/target +'mrt-sword: %Y-%m-%d:%H:%M:%S' >> /build/static/build.content.txt && \
    mvn clean

RUN jar uf /root/.m2/repository/org/cdlib/mrt/mrt-swordwarpub/1.0-SNAPSHOT/mrt-swordwarpub-1.0-SNAPSHOT.war -C /build static/build.content.txt

FROM tomcat:8-jre8

RUN apt-get update

COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-swordwarpub/1.0-SNAPSHOT/mrt-swordwarpub-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/sword.war

EXPOSE 8080 8009

RUN mkdir -p /apps/replic/tst/sword/mrtHomes/sword /tdr/tmpdir

RUN cd /apps/replic/tst/sword/mrtHomes/sword && \
    keytool -genkey -keyalg RSA -alias tomcat -keystore jssecacert \
            -validity 3650 -keysize 2048 -storepass changeit \
            -dname CN=cdlucop,OU=merritt,O=uc3,L=Oakland,ST=CA,C=US < /dev/null

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
