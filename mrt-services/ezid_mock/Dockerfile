#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# See https://itnext.io/docker-rails-puma-nginx-postgres-999cd8866b18
#   docker build -t cdluc3/mrt-dashboard .

FROM ruby:2.6.6
RUN apt-get update -y -qq && apt-get install -y build-essential libpq-dev nodejs

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install --jobs 20 --retry 5
# Adding project files

COPY *.rb .

EXPOSE 4567
CMD ["ruby", "app.rb"]
