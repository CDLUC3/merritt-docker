#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# See https://itnext.io/docker-rails-puma-nginx-postgres-999cd8866b18
#   docker build -t cdluc3/mrt-dashboard .

FROM ruby:2.4.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/app_name
RUN mkdir -p $RAILS_ROOT/stash

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='development'
ENV RACK_ENV='development'

# Adding gems
COPY dryad-app/Gemfile Gemfile
COPY dryad-app/Gemfile.lock Gemfile.lock

COPY dryad-app/lib lib
COPY dryad-app/stash stash

RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY dryad-app .
COPY *.yml config/

RUN bundle exec rake assets:precompile --trace
EXPOSE 3000 9292
CMD ["bundle", "exec", "passenger", "start"]
