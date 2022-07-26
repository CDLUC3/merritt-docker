## Merritt Docker Images used for Code Repo Integration Tests

This folder contains the Dockerfiles to create Merritt docker images that will be launched when running maven integration tests.

Where possible, DEV stack images will be re-used.  When a specialized version of an image is needed to support integration testing, the images will be created here.

## Images

| Status | Image | Base Image | Input | Description |
| ------ | ----- | ---------- | ----- | ----------- |
| In use | pm-server | ruby | S3 bucket with PM data | Sinatra app to make PM data in S3 web-accessible for ingest|
| Deprecated | ezid-store-mock | ruby | | Sinatra mocking EZID and storage calls (deprecated) |
| In use | mock-merritt-it | ruby | mock ingest input | Sinatra app |
| | | mock storage data | - Generates test data for integrtion tests |
| | | mock node definitions | - Mocks responses from Merritt services |
| | | | - Mocks responses from UC services (ezid) |
| In use | mrt-it-database | mysql | schema | Empty Merritt database with schema only |
| In use| mrt-minio-it | minio | | Empty S3 compatible cloud storage with test buckets for nodes 7777 and 8888 |
| TBD | mrt-it-database-populated | mrt-it-database | Mock storage data | Merritt database populated with integration test data using mrt-inventory library calls |
| TBD | mrt-minio-with-content-it | minio | Mock storage/cloud data for integration tests | S3 compatible cloud storage with integration test data |

## Integration Test Configurations
| Status | Repo | Images Used | Notes |
| ------ | ---- | ----------- | ----- |
| done | mrt-cloud | mrt-minio-it | Integration tests run as an executable |
| done | mrt-store | tomcat | Integration tests call service running in a tomcat container | 
| | | mrt-minio-it | |
| | | zoo | |
| deprecated | mrt-ingest (non tomcat) | mrt-minio-it | Integration tests run as an executable, limited coverage since ingest is not running in tomcat |
| | | ezid-store-mock | |
| | | zoo | |
| tbd  | mrt-ingest | tomcat | Integration tests call service running in a tomcat container | 
| | | mock-merritt-it | |
| | | zoo | |
| in progress  | mrt-inventory | tomcat | Integration tests call service running in a tomcat container | 
| | | mock-merritt-it | |
| | | mrt-it-database |  |
| | | zoo | |
| TBD | mrt-replic | tomcat | Integration tests call service running in a tomcat container | 
| | | mrt-it-database | May need to be `mrt-it-database-populated` |
| | | mrt-minio-it | May need to be `mrt-minio-with-content-it` |
| TBD | mrt-audit | tomcat | Integration tests call service running in a tomcat container | 
| | | mrt-it-database-populated | Audit requires data to already exist in the database |
| | | mrt-minio-with-content-it | Audit requires data to already exist in cloud storage|


## Integration Tests to Create by Service

### Inventory
- Save new object to inventory (use manifest as input)
- Update object inventory record
- Delete object inventory record
- Read task from ZK
- Post task update to ZK

### Storage
- Read object from cloud storage
- Write object to cloud storage
- Write object to cloud storage (inject checksum error)
- Get manifest
- Download file
- Create file presign
- Queue assembly task
- Perform assembly task

### Audit
- Audit batch of records
- Audit record (inject checksum error)
- Audit record (inject filesize error)

### Replication
- Create secondary replication
- Update object level replication status