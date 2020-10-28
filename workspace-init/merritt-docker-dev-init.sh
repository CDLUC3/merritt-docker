#! /bin/sh

cd

rm -rf merritt-docker merritt-docker-prv

git clone git@github.com:CDLUC3/merritt-docker.git
git clone git@github.com:cdlib/merritt-docker-prv.git

mkdir merritt-docker/mrt-services/no-track
cp -r merritt-docker-prv/* merritt-docker/mrt-services/no-track

cd merritt-docker
git submodule update --remote --recursive --init -- .

cd mrt-dependencies

cd cdl-zk-queue
git fetch
git checkout master
git pull

cd ../mrt-cloud
git fetch
git checkout minio-8088-only
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

cd ../../../mrt-dependencies
docker-compose build
cd ../mrt-services
docker-compose build
