## Merritt Docker Images used for Code Repo Integration Tests

This folder contains the Dockerfiles to create Merritt docker images that will be launched when running maven integration tests.

Where possible, DEV stack images will be re-used.  When a specialized version of an image is needed to support integration testing, the images will be created here.

## Image Build Script

```
../bin/it_build.sh
```

## Images

| Status | Image | Base Image | Input | Description |
| ------ | ----- | ---------- | ----- | ----------- |
| In use | pm-server | ruby | S3 bucket with PM data | Sinatra app to make PM data in S3 web-accessible for ingest|
| In use | mock-merritt-it | ruby | mock ingest input | Sinatra app |
| | | | mock storage data | - Generates test data for integrtion tests |
| | | | mock node definitions | - Mocks responses from Merritt services |
| | | | | - Mocks responses from UC services (ezid) |
| In use | mrt-it-database | mysql | schema | Empty Merritt database with schema only |
| In use| mrt-minio-it | minio | | Empty S3 compatible cloud storage with test buckets for nodes 7777 and 8888 |
| In use | mrt-it-database-audit-replic | mrt-it-database | Mock storage data | Merritt database populated with integration test data using mrt-inventory library calls |
| In use | mrt-minio-with-content-it | minio | Mock storage/cloud data for integration tests | S3 compatible cloud storage with integration test data |

## Integration Test Configurations
| Status | Repo | Images Used | Notes |
| ------ | ---- | ----------- | ----- |
| done | mrt-cloud | mrt-minio-it | Integration tests run as an executable |
| done | mrt-store | tomcat | Integration tests call service running in a tomcat container | 
| | | mock-merritt-it | |
| | | mrt-minio-it | |
| | | zoo | |
| done  | mrt-ingest | tomcat | Integration tests call service running in a tomcat container | 
| | | mock-merritt-it | |
| | | zoo | |
| | | smtp | |
| done | mrt-inventory | tomcat | Integration tests call service running in a tomcat container | 
| | | mock-merritt-it | |
| | | mrt-it-database |  |
| | | zoo | |
| done | mrt-replic | tomcat | Integration tests call service running in a tomcat container | 
| | | mrt-it-database-audit-replic |  |
| | | mrt-minio-it-with-content | |
| done | mrt-audit | tomcat | Integration tests call service running in a tomcat container | 
| | | mrt-it-database-audit-replic |  |
| | | mrt-minio-it-with-content | |
