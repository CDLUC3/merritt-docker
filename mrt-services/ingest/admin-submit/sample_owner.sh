curl -v \
-F "file=@/tdr/ingest/admin-submit/sample_owner.checkm" \
-F "type=single-file-batch-manifest" \
-F "submitter=merritt-test" \
-F "responseForm=xml" \
-F "profile=admin/docker/owner/sample_owner" \
http://ingest:8080/ingest/poster/update