# Base image for all Merritt tomcat usage

# docker build -t ${ECR_REGISTRY}/merritt-maven:dev .
# aws ecr create-repository --repository-name merritt-maven
# docker push ${ECR_REGISTRY}/merritt-maven:dev

FROM public.ecr.aws/docker/library/maven:3-amazoncorretto-11

ENV JAVA_RELEASE=8
# ENV JAVA_RELEASE=11

RUN yum -y update

RUN mkdir -p /build/static