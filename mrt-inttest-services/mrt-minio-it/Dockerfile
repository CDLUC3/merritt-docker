# Mock ezid and storage service for ingest integration testing

FROM quay.io/minio/minio

ENV MRT_MINIO_HOST "${HOSTNAME}.cdlib.org"

RUN mkdir -p /buckets/my-bucket /buckets/my-bucket-repl

EXPOSE 9000 9001

CMD [ "minio", "server", "/buckets", "--address", ":9000", "--console-address", ":9001" ]