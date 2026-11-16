#!/bin/sh
RUSTFSNAME=${RUSTFSNAME:-minio-server}
rc alias set local http://${RUSTFSNAME}:9000 minioadmin minioadmin
rc cp --recursive /data-load/ local/my-bucket/