aws ecr get-login-password --region us-west-2 | \
  docker login --username AWS \
    --password-stdin ${ECR_REGISTRY}

docker build -t ${ECR_REGISTRY}/dep-cdlmvn:dev dep_cdlmvn

docker push ${ECR_REGISTRY}/dep-cdlmvn:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-core2:dev dep_core

docker push ${ECR_REGISTRY}/mrt-core2:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/cdl-zk-queue:dev dep_cdlzk

docker push ${ECR_REGISTRY}/cdl-zk-queue:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-zoo:dev dep_zoo

docker push ${ECR_REGISTRY}/mrt-zoo:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-cloud:dev dep_cloud

docker push ${ECR_REGISTRY}/mrt-cloud:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-ingest:dev ingest

docker push ${ECR_REGISTRY}/mrt-ingest:dev

docker build -f inventory/Dockerfile-jar --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory-src:dev inventory

docker push ${ECR_REGISTRY}/mrt-inventory-src:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-inventory:dev inventory

docker push ${ECR_REGISTRY}/mrt-inventory:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-store:dev store

docker push ${ECR_REGISTRY}/mrt-store:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-audit:dev audit

docker push ${ECR_REGISTRY}/mrt-audit:dev

docker build --build-arg ECR_REGISTRY=${ECR_REGISTRY} -t ${ECR_REGISTRY}/mrt-replic:dev replic

docker push ${ECR_REGISTRY}/mrt-replic:dev
