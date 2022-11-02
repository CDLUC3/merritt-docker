#*********************************************************************
#   Copyright 2021 Regents of the University of California
#   All rights reserved
#*********************************************************************

# This image is intended to simulate an ALB fronting a Lambda
# docker build -t cdluc3/simulate-lambda-alb .

FROM ruby:3

RUN gem install bundler

COPY Gemfile Gemfile

RUN bundle install

COPY . .

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 8098

CMD ["ruby", "callback.rb"]