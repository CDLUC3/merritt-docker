#! /bin/sh

cd ~dpr2/merritt-workspace/merritt-docker

git fetch
git checkout master
git pull

cd mrt-dependencies

cd cdl-zk-queue
git fetch
git checkout master
git pull

cd ../mrt-cloud
git fetch
git checkout master
git pull

cd ../mrt-core2
git fetch
git checkout master
git pull

cd ../mrt-ingest
git fetch
git checkout master
git pull

cd ../mrt-inventory
git fetch
git checkout master
git pull

cd ../mrt-zoo
git fetch
git checkout master
git pull

cd ../../mrt-services

cd audit/mrt-audit
git fetch
git checkout master
git pull

cd ../../dryad/dryad-app
git fetch
git checkout main
git pull

cd ../../ingest/mrt-ingest
git fetch
git checkout master
git pull

cd ../../inventory/mrt-inventory
git fetch
git checkout master
git pull

cd ../../oai/mrt-oai
git fetch
git checkout master
git pull

cd ../../replic/mrt-replic
git fetch
git checkout master
git pull

cd ../../store/mrt-store
git fetch
git checkout master
git pull

cd ../../sword/mrt-sword
git fetch
git checkout master
git pull

cd ../../ui/mrt-dashboard
git fetch
git checkout rails5-5.2conf
git pull

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

cd ../../../mrt-dependencies
docker-compose build
cd ../mrt-services
docker-compose build
