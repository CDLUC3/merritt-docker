#! /bin/sh

cd ~dpr2/merritt-workspace

rm -rf merritt-docker merritt-docker-prv

git clone git@github.com:CDLUC3/merritt-docker.git
git clone git@github.com:cdlib/merritt-docker-prv.git
git clone git@github.com:cdlib/mrt-integ-tests.git

mkdir merritt-docker/mrt-services/no-track
cp -r merritt-docker-prv/* merritt-docker/mrt-services/no-track

cd merritt-docker
git submodule update --remote --recursive --init -- .
