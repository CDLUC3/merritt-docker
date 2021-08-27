#! /bin/sh

cd /workspaces/merritt-docker 

# Pull in the appropriate branches for each repo
. workspace-init/merritt-docker-branch-refresh.sh

cd mrt-dependencies
docker-compose build

cd ../mrt-services
docker-compose build

cd mrt-admin-lambda
docker-compose build
docker-compose -f docker-compose.yml -f admintool.yml build
docker-compose -f docker-compose.yml -f colladmin.yml build

cd ../ui/mrt-dashboard

export RAILS_ENV=test
bundle install
gem install colorize
gem install capybara
gem install webmock
gem install capybara-webmock
gem install json
gem install equivalent-xml
gem install diffy
gem install factory_bot
gem install chrome
gem install aws-sdk-s3
# Consider: scripting the following to enable irb, rubocop, etc
# mkdir -p ~/gems
# export GEM_HOME=~/gems
# export RAILS_ENV=docker
# export GEM_PATH=~/gems
# bundle install
# gem install bundler:2.1.4
# ~/.gem/ruby/gems/bundler-2.1.4/exe/bundler exec irb

cd ../..