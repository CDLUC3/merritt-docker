FROM public.ecr.aws/docker/library/ubuntu

# Add curl to image
RUN apt-get update -y && \
    apt-get -y upgrade && \
    apt-get install -y curl 
#   apt-get install -y curl && apt-get install -y docker.io

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
