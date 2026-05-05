# Mock ezid and storage service for ingest integration testing

ARG ECR_REGISTRY=ecr_registry_not_set

FROM $ECR_REGISTRY/docker-hub/rustfs/rc AS ecr_registry

FROM ${ECR_REGISTRY}/mock-merritt-it:dev as mock

FROM $ECR_REGISTRY/docker-hub/rustfs/rustfs
ENV RUSTFS_ACCESS_KEY=minioadmin
ENV RUSTFS_SECRET_KEY=minioadmin

COPY --from=ecr_registry /usr/bin/rc /usr/bin/rc

ENV MRT_MINIO_HOST "${HOSTNAME}.cdlib.org"

RUN mkdir -p /data/my-bucket /data/my-bucket-repl

USER root     
RUN mkdir -p /data-load 
COPY --from=mock /data/generated/ /data-load/
RUN chown -R 10001:10001 /data-load
RUN chmod -R 755 /data-load
USER rustfs

RUN rustfs & sleep 3; \
    server_pid=$!; \
    rc alias set local http://localhost:9000 minioadmin minioadmin; \ 
    rc cp --recursive /data-load/ local/my-bucket/; \
    kill $server_pid

EXPOSE 9000 9001