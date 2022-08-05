#!/bin/bash

echo "*** Audit Replic Data Generator"
sleep 10
echo "*** Starting the inventory service"
curl -v -X POST http://it-server:8080/mrtinv/service/start?t=json
curl -v -X POST http://it-server:8080/mrtinv/filenode/7777?t=json
curl -v -X POST http://it-server:8080/mrtinv/filenode/8888?t=json

curl -v http://it-server:8080/mrtinv/state?t=json
sleep 10

echo "*** Add Manifest to INV"

curl -v -X POST http://it-server:8080/mrtinv/add -F responseForm=json \
     -F url=http://mock-merritt-it:4567/storage/manifest/7777/ark%3A%2F1111%2F2222
curl -v -X POST http://it-server:8080/mrtinv/add -F responseForm=json \
     -F url=http://mock-merritt-it:4567/storage/manifest/7777/ark%3A%2F1111%2F3333
curl -v -X POST http://it-server:8080/mrtinv/add -F responseForm=json \
     -F url=http://mock-merritt-it:4567/storage/manifest/7777/ark%3A%2F1111%2F4444

echo "/*See https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/README.md*/" > //audit_replic_data/audit_replic_data.sql
echo "/*See https://github.com/CDLUC3/mrt-inventory/blob/main/inv-it/src/test/README.md*/" >> //audit_replic_data/audit_replic_data.sql
mysqldump -h mrt-it-database -u user --password=password --compact --no-create-info inv >> //audit_replic_data/audit_replic_data.sql