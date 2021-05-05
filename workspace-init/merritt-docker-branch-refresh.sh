#! /bin/sh

git fetch
# do not overwrite merritt-docker branch
# git checkout master
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
git checkout main
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
git checkout main
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

cd ../../audit/mrt-audit
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
git checkout main
git pull

cd ../../mrt-admin-lambda
git fetch
git checkout main
git pull

cd ../..

