# Mock ezid and storage service for ingest integration testing

ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/mock-merritt-it:dev as mock

FROM quay.io/minio/minio

# https://stackoverflow.com/questions/72904999/create-minio-docker-image-with-content
COPY --from=quay.io/minio/mc:latest /usr/bin/mc /usr/bin/mc

ENV MRT_MINIO_HOST "${HOSTNAME}.cdlib.org"

RUN mkdir -p /data-load /buckets/my-bucket /buckets/my-bucket-repl

COPY --from=mock /data/generated/ /data-load/

RUN minio server /buckets & \
    sleep 3; \
    server_pid=$!; \
    until mc alias set local http://localhost:9000 minioadmin minioadmin; do \
        sleep 1; \
    done; \
    mc cp --recursive /data-load/* local/my-bucket; \
    kill $server_pid

EXPOSE 9000 9001

CMD [ "minio", "server", "/buckets", "--address", ":9000", "--console-address", ":9001" ]