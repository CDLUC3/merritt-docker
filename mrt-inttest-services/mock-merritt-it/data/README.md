# Sample Merritt Data Files for Integration Testing

| File | Field | INV Table | INV Column | Note | 
| ---- | ----- | --------- | ---------- | ---- |
| system/mrt-erc.txt | what | inv_objects | erc_what | Unless it comes from mrt-ingest.txt | 
|  | who | inv_objects | erc_who | ^^ | 
|  | when | inv_objects | erc_when | ^^ | 
|  | where | inv_objects | erc_where | values are concatenated | 
|  | (each field) | inv_dublinkernels | value | |
| system/mrtingest.txt | batch | inv_ingests | batch_id | |
|  | job | inv_ingests | job_id | |
| | profile | inv_ingests | profile | |
| | storageNode | inv_nodes_inv_objects | inv_node_id | |
| system/mrt-membership.txt | (content) | inv_collections | ark | |
| | (link) | inv_collections_inv_objects | inv_collection_id | |
| system/mrt-owner.txt | (content) | inv_owners | ark | |
| | (link) | inv_objects | inv_owner_id | |
| system/mrt-mom.txt | type | inv_objects | object_type | |
| | role | inv_objects | aggregate_role | |
| producer/mrt-* | (content) | inv_metadatas | value | |

## Mysql Dump After Single Object Ingest

```
INSERT INTO `inv_audits` VALUES 
  (1,1,1,1,1,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/producer%2Fmrt-dc.xml?fixity=no','unknown','2022-08-02 22:36:08',NULL,NULL,0,NULL,NULL),
  (2,1,1,1,2,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-owner.txt?fixity=no','unknown','2022-08-02 22:36:08',NULL,NULL,0,NULL,NULL),
  (3,1,1,1,3,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-erc.txt?fixity=no','unknown','2022-08-02 22:36:08',NULL,NULL,0,NULL,NULL),
  (4,1,1,1,4,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-mom.txt?fixity=no','unknown','2022-08-02 22:36:08',NULL,NULL,0,NULL,NULL),
  (5,1,1,1,5,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-ingest.txt?fixity=no','unknown','2022-08-02 22:36:08',NULL,NULL,0,NULL,NULL),
  (6,1,1,1,6,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-membership.txt?fixity=no','unknown','2022-08-02 22:36:08',NULL,NULL,0,NULL,NULL),
  (7,1,1,1,7,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/producer%2Fhello.txt?fixity=no','unknown','2022-08-02 22:36:08',NULL,NULL,0,NULL,NULL);
INSERT INTO `inv_collections` VALUES (1,NULL,'ark:/99999/fk4q24532',NULL,NULL,NULL,NULL,NULL,NULL,'none');
INSERT INTO `inv_collections_inv_objects` VALUES (1,1,1);
INSERT INTO `inv_dublinkernels` VALUES 
  (1,1,1,1,'who',NULL,'Merritt Team'),
  (2,1,1,2,'what',NULL,'Hello File'),
  (3,1,1,3,'when',NULL,'2022'),
  (4,1,1,4,'where','primary','ark:/7777/7777'),
  (5,1,1,5,'where','local','my-local-id');
INSERT INTO `inv_files` VALUES 
  (1,1,1,'producer/mrt-dc.xml','producer','data',525,525,'application/xml','sha-256','35dd45b157fc7352ebf2954c4658baa89073cba762fd40b7f9f16bc54a9a2af8','2022-08-02 22:36:08'),
  (2,1,1,'system/mrt-owner.txt','system','data',20,20,'text/plain','sha-256','2f79330df790a7ff3b8cfe580cea1f12d12b316da50679d3f08899ca3dd4f1c9','2022-08-02 22:36:08'),
  (3,1,1,'system/mrt-erc.txt','system','metadata',93,93,'text/plain','sha-256','a5adc23d32740161d2b100069975d3262c79b5c5330edea81c1c09408aaaec49','2022-08-02 22:36:08'),
  (4,1,1,'system/mrt-mom.txt','system','data',104,104,'text/plain','sha-256','b15277ee61ed9a25e753de3c0c71a8ac01066f91322cb16ef07c3690a9f570d3','2022-08-02 22:36:08'),
  (5,1,1,'system/mrt-ingest.txt','system','data',1568,1568,'text/plain','sha-256','8beef10c35d4cfacee042c98fb1587c55e0052f6150ec1e7589d17685836cdb9','2022-08-02 22:36:08'),
  (6,1,1,'system/mrt-membership.txt','system','data',21,21,'text/plain','sha-256','165bcdd5e9202ae2fb872ba6609caf95adcc68a60b39c7d2899bd337014501c8','2022-08-02 22:36:08'),
  (7,1,1,'producer/hello.txt','producer','data',5,5,'text/plain','sha-256','2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824','2022-08-02 22:36:08');
INSERT INTO `inv_ingests` VALUES (1,1,1,'Hello File','file','merritt_content','bid-00000000-0000-0000-0000-000000000000','jid-00000000-0000-0000-0000-000000000000','integration test user','2022-05-07 05:23:42','http://mock-merritt-it:4567/storage/manifest/7777/ark%3A%2F1111%2F2222');
INSERT INTO `inv_metadatas` VALUES (1,1,1,'producer/mrt-dc.xml','DublinCore',NULL,'xml','<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<DublinCore xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n        <dc:title>Hello File</dc:title>\n        <dc:creator>Merritt Team</dc:creator>\n        <dc:type>text</dc:type>\n        <dc:publisher>CDL</dc:publisher>\n        <dc:date>2022</dc:date>\n        <dc:language>eng</dc:language>\n        <dc:description>File used for Merritt Integration Tests.</dc:description>\n        <dc:subject>integration test</dc:subject>\n</DublinCore>');
INSERT INTO `inv_nodes` VALUES 
  (1,7777,'magnetic-disk','cloud','on-line','s3','physical','http','yaml:|7777','nodeio',1,1,'http://mock-merritt-it:4567/store','2022-08-02 22:36:07',NULL,NULL,NULL),
  (2,8888,'magnetic-disk','cloud','on-line','s3','physical','http','yaml:|8888','nodeio',1,1,'http://mock-merritt-it:4567/store','2022-08-02 22:36:07',NULL,NULL,NULL);
INSERT INTO `inv_nodes_inv_objects` VALUES (1,1,1,'primary','2022-08-02 22:36:08',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO `inv_objects` VALUES (1,1,'ark:/1111/2222','d28','MRT-curatorial','MRT-content','MRT-none',1,'Merritt Team','Hello File','2022','ark:/7777/7777 ; my-local-id','2022-08-02 22:36:08','2022-08-03 05:36:08');
INSERT INTO `inv_owners` VALUES (1,NULL,'ark:/99999/fk4tt4wsh',NULL);
INSERT INTO `inv_versions` VALUES (1,1,'ark:/1111/2222',1,NULL,'2022-08-02 22:36:08');
INSERT INTO `sha_dublinkernels` VALUES 
  (1,'Merritt Team'),
  (2,'Hello File'),
  (3,'2022'),
  (4,'ark:/7777/7777'),
  (5,'my-local-id');
```