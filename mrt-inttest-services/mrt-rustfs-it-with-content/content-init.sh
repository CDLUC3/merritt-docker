#!/bin/sh
RUSTFSNAME=${RUSTFSNAME:-minio-server}
RUSTFSPORT=${RUSTFSPORT:-9000}
echo "connecting to http://${RUSTFSNAME}:${RUSTFSPORT}"
# sleep 1
rc alias set local http://${RUSTFSNAME}:${RUSTFSPORT} minioadmin minioadmin
rc cp --recursive /data-load/ local/my-bucket/