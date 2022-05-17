# Mock ezid and storage service for ingest integration testing
#
# docker build -t ${ECR_REGISTRY}/mrt-minio-it:dev .
# aws ecr create-repository --repository-name mrt-minio-it
# docker push ${ECR_REGISTRY}/mrt-minio-it:dev

FROM minio/minio

ENV MRT_MINIO_HOST "${HOSTNAME}.cdlib.org"

RUN mkdir -p /buckets/my-bucket /buckets/my-bucket-repl

EXPOSE 9000 9001

CMD [ "minio", "server", "/buckets", "--address", ":9000", "--console-address", ":9001" ]