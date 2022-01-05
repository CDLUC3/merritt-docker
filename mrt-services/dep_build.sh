aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY} || die "FAIL"

docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn || die "FAIL"

docker push ${ECR_REGISTRY}/dep-cdlmvn:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-core2:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk || die "FAIL"

docker push ${ECR_REGISTRY}/cdl-zk-queue:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-zoo:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-cloud:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-ingest:dev || die "FAIL"

docker build -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} \
  -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-inventory-src:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-inventory:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-store:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-audit:dev || die "FAIL"

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic || die "FAIL"

docker push ${ECR_REGISTRY}/mrt-replic:dev || die "FAIL"
