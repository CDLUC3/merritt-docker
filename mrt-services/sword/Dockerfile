#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# Publish as cdluc3/mrt-sword

#   docker build -t cdluc3/mrt-sword .

FROM cdluc3/mrt-dependencies as build
WORKDIR /tmp/mrt-sword

ADD mrt-sword /tmp/mrt-sword

RUN mvn install && \
    mvn clean

FROM tomcat:8-jre8
COPY --from=build /root/.m2/repository/org/cdlib/mrt/mrt-swordwarpub/1.0-SNAPSHOT/mrt-swordwarpub-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/sword.war

EXPOSE 8080 8009

RUN mkdir -p /apps/replic/tst/sword/mrtHomes/sword

COPY sword-info.txt /apps/replic/tst/sword/mrtHomes/sword

RUN cd /apps/replic/tst/sword/mrtHomes/sword && \
    keytool -genkey -keyalg RSA -alias tomcat -keystore jssecacert \
            -validity 3650 -keysize 2048 -storepass changeit \
            -dname CN=cdlucop,OU=merritt,O=uc3,L=Oakland,ST=CA,C=US < /dev/null
