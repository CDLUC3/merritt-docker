# Mock ezid and storage service for ingest integration testing
#
# docker build -t ${ECR_REGISTRY}/mrt-minio-with-content-it:dev .
# aws ecr create-repository --repository-name mrt-minio-with-content-it
# docker push ${ECR_REGISTRY}/mrt-minio-with-content-it:dev

FROM minio/minio

# https://stackoverflow.com/questions/72904999/create-minio-docker-image-with-content
COPY --from=docker.io/minio/mc:latest /usr/bin/mc /usr/bin/mc

ENV MRT_MINIO_HOST "${HOSTNAME}.cdlib.org"

RUN mkdir -p /data-load /buckets/my-bucket /buckets/my-bucket-repl

COPY data-load/ /data-load

RUN minio server /buckets & \
    server_pid=$!; \
    until mc alias set local http://localhost:9000 minioadmin minioadmin; do \
        sleep 1; \
    done; \
    mc cp --recursive /data-load/* local/my-bucket; \
    kill $server_pid

EXPOSE 9000 9001

CMD [ "minio", "server", "/buckets", "--address", ":9000", "--console-address", ":9001" ]