# Base image for all Merritt tomcat usage

FROM public.ecr.aws/docker/library/tomcat:9-jdk21-corretto

# RUN apt-get update -y && apt-get -y upgrade
RUN yum -y update

EXPOSE 8080 8009

ENV CATALINA_OPTS="-Dfile.encoding=UTF8 -Dorg.apache.tomcat.util.buf.UDecoder.ALLOW_ENCODED_SLASH=true -XX:+UseG1GC"

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone