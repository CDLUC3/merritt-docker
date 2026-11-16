#!/bin/sh
RUSTFSNAME=${RUSTFSNAME:-mrt-minio-it}
rc alias set local http://${RUSTFSNAME}:9000 minioadmin minioadmin
rc cp --recursive /data-load/ local/mrt-config/