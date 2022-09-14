# Mock Merritt Services to Support Integration Testing

This application is a Sinatra app that mocks the behaviors of Merritt microservices for the purpose of integration testing.

This application is also used to manufacture test data (from templates) for integration tests.

- app.rb - Sinatra app to mock Merritt services
- generate.rb - Generates test data for use by audit and replic integration services
- create_audit_replic_data.sh - Generates a mysql dump used by audit and replic integration services

## Accessing the documentation from the Mock Merritt Service:

External Access
- http://localhost:8096/ (substitute your own hostname)

Docker access
- http://mock-merritt-it:4567/ (substitute your own hostname)

---
## Mock Service Endpoints

_Links in this section should be accessed from a running container_


<style>
td, th {
  border: thin solid black;
  padding: 4px;
}

table {
  border-collapse: collapse;
}
</style>

| Status | Method | Endpoint | Used-by | Source Data | Notes |
| ------ | ------ | -------- | ------- | ----------- | ----- |
| implemented | GET    | [/ (this page)](/.)  | n/a     | [README.md](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/README.md) | Documentation, generated from markdown |
| implemented | GET    | [/static/hello.txt](/static/hello.txt) | n/a | [static/hello.txt](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/static/hello.txt) | Sample static content request |
| implemented | GET    | [/store/state/NODE?t=anvl (download)](/store/state/7777?t=anvl) | inv-it | [data/7777.anvl](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/data/7777.anvl)| Storage Node Metadata - used to populate the inv_nodes table |
| implemented | GET    | [/storage/manifest/NODE/ark:/YYYY/ZZZZ](/storage/manifest/7777/ark%3A%2F1111%2F2222) | inv-it | [data/manifest](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/data/manifest) | Generate storage manifest for ark, source file is a mustache template |
| implemented | GET    | [/storage/manifest/NODE/ark:/v3YY/ZZZZ](/storage/manifest/7777/ark%3A%2Fv311%2F2222) | inv-it | [data/manifest](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/data/manifest) | Generate multiversion storage manifest for ark.. returned when ark starts with "v3" |
| implemented | GET    | [/storage/content/NODE/ark:/YYYY/ZZZZ/VER/system/PATH](/storage/content/7777/ark%3A%2F1111%2F2222/1/system/mrt-erc.txt) | inv-it | [data/system/mrt-erc.txt](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/data/system/mrt-erc.txt) | Retrieve sample system file |
| implemented | GET    | [/store/content/NODE/ark:/YYYY/ZZZZ/VER/system/PATH](/store/content/7777/ark%3A%2F1111%2F2222/1/system/mrt-erc.txt) | ??? | ^^ | ^^ |
| implemented | GET    | [/storage-input/system/PATH](/storage-input/system/mrt-erc.txt) | store-it | ^^ | ^^ |
| implemented | GET    | [/storage/content/NODE/ark:/YYYY/ZZZZ/VER/producer/PATH](/storage/content/7777/ark%3A%2F1111%2F2222/1/producer/hello.txt) | inv-it | [data/producer/hello.txt](https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/data/producer/hello.txt) | Retrieve sample producer file |
| implemented | GET    | [/store/content/NODE/ark:/YYYY/ZZZZ/VER/producer/PATH](/store/content/7777/ark%3A%2F1111%2F2222/1/producer/hello.txt) | ??? |  ^^ | ^^ |
| implemented | GET    | [/storage-input/producer/PATH](/storage-input/producer/hello.txt) | store-it | ^^ | ^^ |
| implemented | POST   | /id/*ark* | ingest-it | | Mock data update for ark |
| implemented | POST   | /shoulder/*shoulder* | ingest-it | | Mock ark creation for a given shoulder |
| implemented | POST   | /add/*/* | ingest-it | | Mock storage add|
| implemented | POST   | /update/* | ingest-it | | Mock storage update|
| implemented | POST   | /status/start | ingest-it | | Resume serving data|
| implemented | POST   | /status/stop  | ingest-it | | Temporarily stop serving data|
| implemented | GET    | /status  | ingest-it | | Check if service is serving data|
| implemented | GET    | /hostname  | ingest-it | | Ask mock storage service for its hostname|
| implemented | GET    | /inventory/* | ingest-it | | Mock inventory call|
| implemented | POST   | /inventory/* | ingest-it | | Mock inventory call|
