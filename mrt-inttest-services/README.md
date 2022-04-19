## Merritt Docker Images used for Code Repo Integration Tests

This folder contains the Dockerfiles to create Merritt docker images that will be launched when running maven integration tests.

Where possible, DEV stack images will be re-used.  When a specialized version of an image is needed to support integration testing, the images will be created here.

## Anticipated Images
| Image name | Source Code | Base Image | Used By | Status |
|-------------|--------------|-------------|----------|-------|
|.../mrt-database|mrt-services/mysql|mysql:5.7|ui|in use|
|.../mrt-database-populated|mrt-inttest-services|.../mrt-database|inv,audit,replic|proposed|
|.../ezid_mock|mrt-services/ezid_mock|ruby|ingest, inv?|in use|
|.../mrt-zookeeper|mrt-services/zoo|zookeeper|ingest, inv, store|proposed|
|.../minio-populated|mrt-inttest-services|minio|store, audit, replic|proposed|

## Integration Tests to Create by Service