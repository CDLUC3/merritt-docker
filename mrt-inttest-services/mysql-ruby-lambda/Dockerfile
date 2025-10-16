#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

FROM public.ecr.aws/lambda/ruby:3.3

RUN dnf -y update && dnf -y upgrade

# Install an os-specific MySQL installation.  
# gcc and make are required to build mysql.
# UC3 ruby code pulls a common gem from github for use in Lambda code.
# RUN yum -y install mysql-devel gcc make git
RUN dnf -y install mariadb105-devel gcc make git

RUN gem update bundler

# Start with a Gemfile containing only MySQL
COPY * ./

RUN bundle config --local build.mysql2 --with-mysql2-config=/usr/lib64/mysql/mysql_config && \
    bundle config --local silence_root_warning true && \
    bundle config set path 'vendor/bundle' && \
    bundle install

# This structure assumes the following:
#   lambda_function.rb contains a module name LambdaFunctions which contains a class Handler
# That class conforms to the method signature expected for a Lambda.
CMD [ "lambda_function.LambdaFunctions::Handler.process" ]
