#! /bin/sh

cd ~dpr2/merritt-workspace/merritt-docker

# Pull in the appropriate branches for each repo
. merritt-docker-branch-refresh.sh

cd mrt-services/ui

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
# Consider: scripting the following to enable irb, rubocop, etc
# mkdir -p ~/gems
# export GEM_HOME=~/gems
# export RAILS_ENV=docker
# export GEM_PATH=~/gems
# bundle install
# gem install bundler:2.1.4
# ~/.gem/ruby/gems/bundler-2.1.4/exe/bundler exec irb

cd ../..