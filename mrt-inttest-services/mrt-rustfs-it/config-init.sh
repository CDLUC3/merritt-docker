#!/bin/sh
rc alias set local http://mrt-minio-it:9000 minioadmin minioadmin
rc cp --recursive /data-load/ local/mrt-config/