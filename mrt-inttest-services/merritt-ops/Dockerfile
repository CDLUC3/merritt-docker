FROM public.ecr.aws/ubuntu/ubuntu

# Install common development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    mysql-client \
    apache2 \
    nano \
    python3 \
    python3-pip \
    ruby \
    ruby-dev \
    openjdk-17-jdk \
    unzip \
    zip \
    jq \
    yq \
    time \
    net-tools \
    iputils-ping \
    mandoc \
    && apt-get clean

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

COPY README.md /README.md
COPY scripts /
RUN chmod 744 /*.sh

RUN mkdir -p /root/.aws
COPY .awsconfig-template /root/.aws/config
COPY .awscredentials-template /root/.aws/credentials
RUN chmod 400 /root/.aws/config /root/.aws/credentials

# Write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

EXPOSE 80

CMD service apache2 start && \
    tail -f /var/log/apache2/access.log /var/log/apache2/error.log  
