#!/bin/bash

ROOTDIR=$(realpath $(dirname $(dirname -- "$0")))
echo $ROOTDIR


cd ${ROOTDIR}/mrt-inttest-services/mock-merritt-it

echo
pwd
echo '==========='
echo '  mock-merritt-it'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-integ-tests

echo
pwd
echo '==========='
echo '  mrt-integ-tests'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-other/uc3-ssm

echo
pwd
echo '==========='
echo '  uc3-ssm'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/dep_zk/mrt-zk/src/main/ruby
echo
pwd
echo '==========='
echo '  mrt-zk'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/ui/mrt-dashboard
echo
pwd
echo '==========='
echo '  mrt-dashboard'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/callback
echo
pwd
echo '==========='
echo '  callback'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/mrt-admin-sinatra

echo
pwd
echo '==========='
echo '  mrt-admin-sinatra'
echo '==========='
bundle update --bundler 2>&1 | grep -v "is ignoring" || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-services/mrt-admin-lambda

cd mysql-ruby-lambda
echo
pwd
echo '==========='
echo '  mysql-ruby-lambda'
echo '==========='
bundle update --bundler 2>&1 | grep -v "is ignoring" || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A|| exit
cd ../src-common
echo
pwd
echo '==========='
echo '  src-common'
echo '==========='
bundle update --bundler 2>&1 | grep -v "is ignoring" || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit
cd ../src-admintool
echo
pwd
echo '==========='
echo '  src-admintool'
echo '==========='
bundle update --bundler 2>&1 | grep -v "is ignoring" || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A|| exit
cd ../src-colladmin
echo
pwd
echo '==========='
echo '  src-colladmin'
echo '==========='
rm -rf vendor/bundle/ruby/3*/bundler/gems/mrt-zk*
bundle update --bundler 2>&1 | grep -v "is ignoring" || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A|| exit
cd ../src-testdriver
echo
pwd
echo '==========='
echo '  src-testdriver'
echo '==========='
bundle update --bundler 2>&1 | grep -v "is ignoring" || exit
bundle install || exit
bundle update || exit
bundle exec rubocop || exit

cd ${ROOTDIR}/mrt-other/mrt-cron

cd coll-health
echo
pwd
echo '==========='
echo '  coll-health'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit
cd ../coll-health-obj-analysis
echo
pwd
echo '==========='
echo '  coll-health-obj-analysis'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit
cd ../consistency-driver
echo
pwd
echo '==========='
echo '  consistency-driver'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-other/s3-sinatra

echo
pwd
echo '==========='
echo '  s3-sinatra'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
bundle exec rubocop -A || exit

cd ${ROOTDIR}/mrt-other/mrt-atom

echo
pwd
echo '==========='
echo '  mrt-atom'
echo '==========='
bundle update --bundler || exit
bundle install || exit
bundle update || exit
# rubocop is not applicable