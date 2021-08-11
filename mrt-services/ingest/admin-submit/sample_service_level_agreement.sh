curl -v \
-F "file=@/tdr/ingest/admin-submit/sample_service_level_agreement.checkm" \
-F "type=single-file-batch-manifest" \
-F "submitter=merritt-test" \
-F "responseForm=xml" \
-F "profile=admin/docker/sla/sample_service_level_agreement" \
http://ingest:8080/ingest/poster/update