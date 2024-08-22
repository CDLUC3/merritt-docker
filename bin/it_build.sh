#!/bin/sh
docker-compose \
  -f mrt-inttest-services/merritt-maven/docker-compose.yml \
  -f mrt-inttest-services/merritt-tomcat/docker-compose.yml \
  -f mrt-inttest-services/mock-merritt-it/docker-compose.yml \
  -f mrt-inttest-services/mrt-it-database/docker-compose.yml \
  -f mrt-inttest-services/mrt-it-database/docker-compose-audit-replic.yml \
  -f mrt-inttest-services/mrt-minio-it/docker-compose.yml \
  -f mrt-inttest-services/mrt-minio-it-with-content/docker-compose.yml build