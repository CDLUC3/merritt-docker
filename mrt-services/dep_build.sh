aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY} || exit 1

echo
echo "Running docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn"
docker build --force-rm -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn || exit 1
docker push ${ECR_REGISTRY}/dep-cdlmvn:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core || exit 1
docker push ${ECR_REGISTRY}/mrt-core2:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk || exit 1
docker push ${ECR_REGISTRY}/cdl-zk-queue:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo || exit 1
docker push ${ECR_REGISTRY}/mrt-zoo:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud || exit 1
docker push ${ECR_REGISTRY}/mrt-cloud:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest || exit 1
docker push ${ECR_REGISTRY}/mrt-ingest:dev || exit 1

echo
echo "Running docker build -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory"
docker build --force-rm -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} \
  -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory || exit 1
docker push ${ECR_REGISTRY}/mrt-inventory-src:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory || exit 1
docker push ${ECR_REGISTRY}/mrt-inventory:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store || exit 1
docker push ${ECR_REGISTRY}/mrt-store:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit || exit 1
docker push ${ECR_REGISTRY}/mrt-audit:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic || exit 1
docker push ${ECR_REGISTRY}/mrt-replic:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-oai:dev oai"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-oai:dev oai || exit 1
docker push ${ECR_REGISTRY}/mrt-oai:dev || exit 1

echo
echo "Running docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-sword:dev sword"
docker build --force-rm --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-sword:dev sword || exit 1
docker push ${ECR_REGISTRY}/mrt-sword:dev || exit 1
