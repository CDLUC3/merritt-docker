#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# See https://itnext.io/docker-rails-puma-nginx-postgres-999cd8866b18
#   docker build -t cdluc3/mrt-dashboard .

FROM ruby:2.6.6
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/app_name
RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='development'
ENV RACK_ENV='development'

# Adding gems
COPY mrt-dashboard/Gemfile Gemfile
COPY mrt-dashboard/Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY mrt-dashboard .

ENV SSM_SKIP_RESOLUTION=Y
RUN bundle exec rake assets:precompile
EXPOSE 3000 8089 1234

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# CA cert for LDAP SSL access
RUN mkdir /usr/local/share/ca-certificates/extra
COPY ldap-ca.crt /usr/local/share/ca-certificates/extra/ldap-ca.crt
RUN /usr/sbin/update-ca-certificates

CMD ["bundle", "exec", "puma", "-C", "config/application.rb", "-p", "8089"]
