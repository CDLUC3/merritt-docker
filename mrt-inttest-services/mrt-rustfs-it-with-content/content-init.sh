#!/bin/sh
RUSTFSNAME=${RUSTFSNAME:-minio-server}
echo "connecting to http://${RUSTFSNAME}:9000"
sleep 1
rc alias set local http://${RUSTFSNAME}:9000 minioadmin minioadmin
rc cp --recursive /data-load/ local/my-bucket/