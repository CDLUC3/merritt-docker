FROM public.ecr.aws/ubuntu/ubuntu

# Install common development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    mysql-client libmariadb-dev \
    apache2 \
    nano \
    python3-full \
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
    expect \
    csh \
    && apt-get clean

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# this may not actually install on arm, but is is primarily needed for ecs
RUN curl -o "session-manager-plugin.deb" "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" && \
    dpkg -i session-manager-plugin.deb || echo "Failed to install session-manager-plugin" && \
    rm session-manager-plugin.deb

RUN gem install bundler

COPY README.md /README.md
COPY scripts /
RUN chmod 744 /*.sh /mrt-locust/*.sh

RUN git clone https://github.com/CDLUC3/mrt-atom.git && cd mrt-atom && bundle install \
    && mkdir bin LockFile LastUpdate logs \
    && aws s3 sync "s3://${S3CONFIG_BUCKET}/uc3/mrt/mrt-ingest-profiles/nuxeo/" bin

RUN mkdir -p /root/.aws
COPY .awsconfig-template /root/.aws/config
COPY .awscredentials-template /root/.aws/credentials
COPY .bashrc.append /tmp/.bashrc.append
RUN chmod 400 /root/.aws/config /root/.aws/credentials

RUN useradd -u 1001 opendj

RUN cat /tmp/.bashrc.append >> /root/.bashrc

# Write hello world message
RUN echo 'Hello World!' > /var/www/html/index.html

EXPOSE 80

CMD service apache2 start && \
    tail -f /var/log/apache2/access.log /var/log/apache2/error.log  
