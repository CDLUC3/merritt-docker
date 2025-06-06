FROM ubuntu

# Install common development tools
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    curl \
    wget \
    vim \
    mysql-client \
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

CMD ["tail", "-f", "/dev/null"]

# Set up a non-root user (optional)
# RUN useradd -ms /bin/bash devuser
# USER devuser
# WORKDIR /home/devuser