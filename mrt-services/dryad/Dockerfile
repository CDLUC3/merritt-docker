#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
#   docker build -t cdluc3/dryad .
#
# Create super user example:
# docker exec -it dryad-db mysql --password=root-password --database=dryad
# update stash_engine_users set role='superuser' where orcid='0000-0002-5961-0685';

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

COPY dryad-app .
COPY *.yml config/
RUN mkdir -p config/tenants
COPY tenants/dryad.yml config/tenants/
COPY stash-notifier/notifier.yml stash/stash-notifier/config/

RUN bundle install --jobs 20 --retry 5 && \
    bundle exec rake assets:precompile --trace && \
    cd stash/stash-notifier && \
    bundle install

EXPOSE 3000 9292
CMD ["bundle", "exec", "passenger", "start"]
