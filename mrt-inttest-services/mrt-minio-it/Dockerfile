# Mock ezid and storage service for ingest integration testing

FROM quay.io/minio/minio

# https://stackoverflow.com/questions/72904999/create-minio-docker-image-with-content
COPY --from=quay.io/minio/mc:latest /usr/bin/mc /usr/bin/mc

ENV MRT_MINIO_HOST "${HOSTNAME}.cdlib.org"

RUN mkdir -p /data-load/uc3/mrt /buckets/my-bucket /buckets/my-bucket-repl /buckets/my-bucket-repl2 /buckets/mrt-config /buckets/mrt-reports

# Eventually, this data load content should be built into a docker image mrt-ingest-profiles:latest
# and copied from there.  For now, the desired content is local to this repo.
COPY mrt-config /data-load/uc3/mrt

RUN minio server /buckets & \
    sleep 3; \
    server_pid=$!; \
    until mc alias set local http://localhost:9000 minioadmin minioadmin; do \
        sleep 1; \
    done; \
    mc cp --recursive /data-load/* local/mrt-config; \
    kill $server_pid

EXPOSE 9000 9001

CMD [ "minio", "server", "/buckets", "--address", ":9000", "--console-address", ":9001" ]