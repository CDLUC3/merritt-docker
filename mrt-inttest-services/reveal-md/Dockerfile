ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/docker-hub/webpronl/reveal-md

# Update packages and npm dependencies to address security vulnerabilities
RUN apk update && apk upgrade 
RUN cd /app && npm update
