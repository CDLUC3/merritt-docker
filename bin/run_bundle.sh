#!/bin/bash

ROOTDIR=$(realpath $(dirname $(dirname -- "$0")))
echo $ROOTDIR


cd ${ROOTDIR}/mrt-inttest-services/mock-merritt-it

echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-integ-tests

echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-other/uc3-ssm

echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/dep_zk/mrt-zk/src/main/ruby
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/ui/mrt-dashboard
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/mrt-admin-sinatra

echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/mrt-admin-lambda

cd mysql-ruby-lambda
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop || exit
cd ../src-common
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop || exit
cd ../src-admintool
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop || exit
cd ../src-colladmin
echo
pwd
echo '==========='
rm -rf vendor/bundle/ruby/3*/bundler/gems/mrt-zk*
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop || exit
cd ../src-testdriver
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop || exit

cd ${ROOTDIR}/mrt-other/mrt-cron

cd coll-health
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit
cd ../coll-health-obj-analysis
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit
cd ../consistency-driver
echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-other/s3-sinatra

echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-other/mrt-atom

echo
pwd
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
# rubocop is not applicable