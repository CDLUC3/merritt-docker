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
    net-tools \
    iputils-ping \
    && apt-get clean

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

COPY README.md /README.md

# Write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

EXPOSE 80

CMD service apache2 start && \
    tail -f /var/log/apache2/access.log /var/log/apache2/error.log  
