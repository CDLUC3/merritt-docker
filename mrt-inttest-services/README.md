## Merritt Docker Images used for Code Repo Integration Tests

This folder contains the Dockerfiles to create Merritt docker images that will be launched when running maven integration tests.

Where possible, DEV stack images will be re-used.  When a specialized version of an image is needed to support integration testing, the images will be created here.

## Anticipated Images
| Image name | Source Code | Base Image | Used By | Status |
|-------------|--------------|-------------|----------|-------|
|.../mrt-database|mrt-services/mysql|mysql:5.7|ui|in use|
|.../mrt-database-populated|mrt-inttest-services|.../mrt-database|inv,audit,replic|proposed|
|.../ezid_store_mock|mrt-inttest-services|ruby|ingest, inv|proposed|
|.../mrt-zookeeper|mrt-services/zoo|zookeeper|ingest, inv, store|proposed|
|.../minio-populated|mrt-inttest-services|minio|store, audit, replic|proposed|

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