# Mock Merritt Services to Support Integration Testing

This application is a Sinatra app that mocks the behaviors of Merritt microservices for the purpose of integration testing.

This application is also used to manufacture test data (from templates) for integration tests.

## Implemented Endpoints

| Method | Endpoint | Used-by | Notes |
| ------ | -------- | ----- | ----- |
| GET    | /data/*NODE*?t=anvl | inv-it | Storage Node Metadata - used to populate the inv_nodes table |
| GET    | /static/*           | Return a file stored in the image |
| GET    | /static/storage/manifest/*NODE*/*ark* | inv-it | Return manifest.xml for an object |
| GET    | /static/storage/content/*NODE*/*ark*/*version*/*path* | inv-it|  Return file content |

## To be implemented 

| Method | Endpoint | Used by | Notes |
| ------ | -------- | ------- | ----- |
| GET    | /static/storage-input | store-it | Input data to be loaded via storage, simulates data on EFS drive |
| GET    | /id/*ark* | | Mock ezid, is this used? |
| GET    | /shoulder/*shoulder* | | Mock ezid, is this used? |
| POST   | /id/*ark* | ingest-it | Mock data update for ark |
| POST   | /shoulder/*shoulder* | ingest-it | Mock ark creation for a given shoulder |
| POST   | /add/* | ingest-it | Mock storage add|
