# Base image for all Merritt tomcat usage

FROM public.ecr.aws/docker/library/tomcat:11-jdk21-corretto

# RUN apt-get update -y && apt-get -y upgrade
RUN yum -y update

EXPOSE 8080 8009

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY valve.txt /tmp
COPY modify_server.jsh /tmp
RUN cp /usr/local/tomcat/conf/server.xml /tmp/server.xml
RUN jshell -s /tmp/modify_server.jsh > /usr/local/tomcat/conf/server.xml
COPY log4j2-ecs.xml /