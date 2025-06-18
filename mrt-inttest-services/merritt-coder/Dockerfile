ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/docker-hub/codercom/code-server:latest

USER root

RUN mkdir -p /root/project /root/.config/code-server

COPY config.yaml /root/.config/code-server/ 
