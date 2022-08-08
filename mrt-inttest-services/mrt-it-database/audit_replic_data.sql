/*See https://github.com/CDLUC3/merritt-docker/blob/main/mrt-inttest-services/mock-merritt-it/README.md*/
/*See https://github.com/CDLUC3/mrt-inventory/blob/main/inv-it/src/test/README.md*/
INSERT INTO `inv_audits` VALUES (1,1,1,1,1,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/producer%2Fmrt-dc.xml?fixity=no','unknown','2022-08-05 00:26:42',NULL,NULL,0,NULL,NULL),(2,1,1,1,2,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-owner.txt?fixity=no','unknown','2022-08-05 00:26:42',NULL,NULL,0,NULL,NULL),(3,1,1,1,3,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-erc.txt?fixity=no','unknown','2022-08-05 00:26:42',NULL,NULL,0,NULL,NULL),(4,1,1,1,4,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-mom.txt?fixity=no','unknown','2022-08-05 00:26:42',NULL,NULL,0,NULL,NULL),(5,1,1,1,5,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-ingest.txt?fixity=no','unknown','2022-08-05 00:26:42',NULL,NULL,0,NULL,NULL),(6,1,1,1,6,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/system%2Fmrt-membership.txt?fixity=no','unknown','2022-08-05 00:26:42',NULL,NULL,0,NULL,NULL),(7,1,1,1,7,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F2222/1/producer%2Fhello.txt?fixity=no','unknown','2022-08-05 00:26:42',NULL,NULL,0,NULL,NULL),(8,1,2,2,8,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F3333/1/producer%2Fmrt-dc.xml?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(9,1,2,2,9,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F3333/1/system%2Fmrt-owner.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(10,1,2,2,10,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F3333/1/system%2Fmrt-erc.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(11,1,2,2,11,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F3333/1/system%2Fmrt-mom.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(12,1,2,2,12,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F3333/1/system%2Fmrt-ingest.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(13,1,2,2,13,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F3333/1/system%2Fmrt-membership.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(14,1,2,2,14,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F3333/1/producer%2Fhello.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(15,1,3,3,15,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F4444/1/producer%2Fmrt-dc.xml?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(16,1,3,3,16,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F4444/1/system%2Fmrt-owner.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(17,1,3,3,17,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F4444/1/system%2Fmrt-erc.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(18,1,3,3,18,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F4444/1/system%2Fmrt-mom.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(19,1,3,3,19,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F4444/1/system%2Fmrt-ingest.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(20,1,3,3,20,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F4444/1/system%2Fmrt-membership.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL),(21,1,3,3,21,'http://mock-merritt-it:4567/storage/content/7777/ark%3A%2F1111%2F4444/1/producer%2Fhello.txt?fixity=no','unknown','2022-08-05 00:26:43',NULL,NULL,0,NULL,NULL);
INSERT INTO `inv_collections` VALUES (1,NULL,'ark:/99999/collection',NULL,NULL,NULL,NULL,NULL,NULL,'none');
INSERT INTO `inv_collections_inv_nodes` VALUES (1,1,2,'2022-08-05 16:28:29');
INSERT INTO `inv_collections_inv_objects` VALUES (1,1,1),(2,1,2),(3,1,3);
INSERT INTO `inv_dublinkernels` VALUES (1,1,1,1,'who',NULL,'Merritt Team'),(2,1,1,2,'what',NULL,'Hello File'),(3,1,1,3,'when',NULL,'2022'),(4,1,1,4,'where','primary','ark:/7777/7777'),(5,1,1,5,'where','local','my-local-id'),(6,2,2,1,'who',NULL,'Merritt Team'),(7,2,2,2,'what',NULL,'Hello File'),(8,2,2,3,'when',NULL,'2022'),(9,2,2,4,'where','primary','ark:/7777/7777'),(10,2,2,5,'where','local','my-local-id'),(11,3,3,1,'who',NULL,'Merritt Team'),(12,3,3,2,'what',NULL,'Hello File'),(13,3,3,3,'when',NULL,'2022'),(14,3,3,4,'where','primary','ark:/7777/7777'),(15,3,3,5,'where','local','my-local-id');
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER insert_fulltext
AFTER INSERT ON inv_dublinkernels
FOR EACH ROW
BEGIN
  IF NOT NEW.value='(:unas)' THEN
    INSERT INTO sha_dublinkernels
    VALUES (NEW.id, NEW.value);
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER update_fulltext
AFTER UPDATE ON inv_dublinkernels
FOR EACH ROW
BEGIN
  IF NEW.value!='(:unas)' THEN
    UPDATE sha_dublinkernels
    SET value = NEW.value
    WHERE id = NEW.id;
  END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = latin1 */ ;
/*!50003 SET character_set_results = latin1 */ ;
/*!50003 SET collation_connection  = latin1_swedish_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER delete_fulltext
AFTER DELETE ON inv_dublinkernels
FOR EACH ROW
BEGIN
  DELETE FROM sha_dublinkernels
  WHERE id = OLD.id;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
INSERT INTO `inv_files` VALUES (1,1,1,'producer/mrt-dc.xml','producer','data',525,525,'application/xml','sha-256','35dd45b157fc7352ebf2954c4658baa89073cba762fd40b7f9f16bc54a9a2af8','2022-08-05 00:26:42'),(2,1,1,'system/mrt-owner.txt','system','data',16,16,'text/plain','sha-256','1a00b96724193d940c3823c981bd95dce7b5785d468d79971fc188555c35e4f0','2022-08-05 00:26:42'),(3,1,1,'system/mrt-erc.txt','system','metadata',93,93,'text/plain','sha-256','a5adc23d32740161d2b100069975d3262c79b5c5330edea81c1c09408aaaec49','2022-08-05 00:26:42'),(4,1,1,'system/mrt-mom.txt','system','data',104,104,'text/plain','sha-256','b15277ee61ed9a25e753de3c0c71a8ac01066f91322cb16ef07c3690a9f570d3','2022-08-05 00:26:42'),(5,1,1,'system/mrt-ingest.txt','system','data',1568,1568,'text/plain','sha-256','8beef10c35d4cfacee042c98fb1587c55e0052f6150ec1e7589d17685836cdb9','2022-08-05 00:26:42'),(6,1,1,'system/mrt-membership.txt','system','data',22,22,'text/plain','sha-256','be4528f2066fb75a898710cc7bc321dfea67c02a7c5887cc95b0a18800fd4e53','2022-08-05 00:26:42'),(7,1,1,'producer/hello.txt','producer','data',5,5,'text/plain','sha-256','2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824','2022-08-05 00:26:42'),(8,2,2,'producer/mrt-dc.xml','producer','data',525,525,'application/xml','sha-256','35dd45b157fc7352ebf2954c4658baa89073cba762fd40b7f9f16bc54a9a2af8','2022-08-05 00:26:43'),(9,2,2,'system/mrt-owner.txt','system','data',16,16,'text/plain','sha-256','1a00b96724193d940c3823c981bd95dce7b5785d468d79971fc188555c35e4f0','2022-08-05 00:26:43'),(10,2,2,'system/mrt-erc.txt','system','metadata',93,93,'text/plain','sha-256','a5adc23d32740161d2b100069975d3262c79b5c5330edea81c1c09408aaaec49','2022-08-05 00:26:43'),(11,2,2,'system/mrt-mom.txt','system','data',104,104,'text/plain','sha-256','b15277ee61ed9a25e753de3c0c71a8ac01066f91322cb16ef07c3690a9f570d3','2022-08-05 00:26:43'),(12,2,2,'system/mrt-ingest.txt','system','data',1568,1568,'text/plain','sha-256','8beef10c35d4cfacee042c98fb1587c55e0052f6150ec1e7589d17685836cdb9','2022-08-05 00:26:43'),(13,2,2,'system/mrt-membership.txt','system','data',22,22,'text/plain','sha-256','be4528f2066fb75a898710cc7bc321dfea67c02a7c5887cc95b0a18800fd4e53','2022-08-05 00:26:43'),(14,2,2,'producer/hello.txt','producer','data',5,5,'text/plain','sha-256','2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824','2022-08-05 00:26:43'),(15,3,3,'producer/mrt-dc.xml','producer','data',525,525,'application/xml','sha-256','35dd45b157fc7352ebf2954c4658baa89073cba762fd40b7f9f16bc54a9a2af8','2022-08-05 00:26:43'),(16,3,3,'system/mrt-owner.txt','system','data',16,16,'text/plain','sha-256','1a00b96724193d940c3823c981bd95dce7b5785d468d79971fc188555c35e4f0','2022-08-05 00:26:43'),(17,3,3,'system/mrt-erc.txt','system','metadata',93,93,'text/plain','sha-256','a5adc23d32740161d2b100069975d3262c79b5c5330edea81c1c09408aaaec49','2022-08-05 00:26:43'),(18,3,3,'system/mrt-mom.txt','system','data',104,104,'text/plain','sha-256','b15277ee61ed9a25e753de3c0c71a8ac01066f91322cb16ef07c3690a9f570d3','2022-08-05 00:26:43'),(19,3,3,'system/mrt-ingest.txt','system','data',1568,1568,'text/plain','sha-256','8beef10c35d4cfacee042c98fb1587c55e0052f6150ec1e7589d17685836cdb9','2022-08-05 00:26:43'),(20,3,3,'system/mrt-membership.txt','system','data',22,22,'text/plain','sha-256','be4528f2066fb75a898710cc7bc321dfea67c02a7c5887cc95b0a18800fd4e53','2022-08-05 00:26:43'),(21,3,3,'producer/hello.txt','producer','data',5,5,'text/plain','sha-256','2cf24dba5fb0a30e26e83b2ac5b9e29e1b161e5c1fa7425e73043362938b9824','2022-08-05 00:26:43');
INSERT INTO `inv_ingests` VALUES (1,1,1,'Hello File','file','merritt_content','bid-00000000-0000-0000-0000-000000000000','jid-00000000-0000-0000-0000-000000000000','integration test user','2022-05-07 05:23:42','http://mock-merritt-it:4567/storage/manifest/7777/ark%3A%2F1111%2F2222'),(2,2,2,'Hello File','file','merritt_content','bid-00000000-0000-0000-0000-000000000000','jid-00000000-0000-0000-0000-000000000000','integration test user','2022-05-07 05:23:42','http://mock-merritt-it:4567/storage/manifest/7777/ark%3A%2F1111%2F3333'),(3,3,3,'Hello File','file','merritt_content','bid-00000000-0000-0000-0000-000000000000','jid-00000000-0000-0000-0000-000000000000','integration test user','2022-05-07 05:23:42','http://mock-merritt-it:4567/storage/manifest/7777/ark%3A%2F1111%2F4444');
INSERT INTO `inv_metadatas` VALUES (1,1,1,'producer/mrt-dc.xml','DublinCore',NULL,'xml','<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<DublinCore xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n        <dc:title>Hello File</dc:title>\n        <dc:creator>Merritt Team</dc:creator>\n        <dc:type>text</dc:type>\n        <dc:publisher>CDL</dc:publisher>\n        <dc:date>2022</dc:date>\n        <dc:language>eng</dc:language>\n        <dc:description>File used for Merritt Integration Tests.</dc:description>\n        <dc:subject>integration test</dc:subject>\n</DublinCore>'),(2,2,2,'producer/mrt-dc.xml','DublinCore',NULL,'xml','<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<DublinCore xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n        <dc:title>Hello File</dc:title>\n        <dc:creator>Merritt Team</dc:creator>\n        <dc:type>text</dc:type>\n        <dc:publisher>CDL</dc:publisher>\n        <dc:date>2022</dc:date>\n        <dc:language>eng</dc:language>\n        <dc:description>File used for Merritt Integration Tests.</dc:description>\n        <dc:subject>integration test</dc:subject>\n</DublinCore>'),(3,3,3,'producer/mrt-dc.xml','DublinCore',NULL,'xml','<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<DublinCore xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">\n        <dc:title>Hello File</dc:title>\n        <dc:creator>Merritt Team</dc:creator>\n        <dc:type>text</dc:type>\n        <dc:publisher>CDL</dc:publisher>\n        <dc:date>2022</dc:date>\n        <dc:language>eng</dc:language>\n        <dc:description>File used for Merritt Integration Tests.</dc:description>\n        <dc:subject>integration test</dc:subject>\n</DublinCore>');
INSERT INTO `inv_nodes` VALUES (1,7777,'magnetic-disk','cloud','on-line','s3','physical','http','yaml:|7777','nodeio',1,1,'http://mock-merritt-it:4567/store','2022-08-05 00:26:32',NULL,NULL,NULL),(2,8888,'magnetic-disk','cloud','on-line','s3','physical','http','yaml:|8888','nodeio',1,1,'http://mock-merritt-it:4567/store','2022-08-05 00:26:32',NULL,NULL,NULL);
INSERT INTO `inv_nodes_inv_objects` VALUES (1,1,1,'primary','2022-08-05 00:26:42',NULL,NULL,NULL,NULL,NULL,NULL),(2,1,2,'primary','2022-08-05 00:26:43',NULL,NULL,NULL,NULL,NULL,NULL),(3,1,3,'primary','2022-08-05 00:26:43',NULL,NULL,NULL,NULL,NULL,NULL);
INSERT INTO `inv_objects` VALUES (1,1,'ark:/1111/2222','d28','MRT-curatorial','MRT-content','MRT-none',1,'Merritt Team','Hello File','2022','ark:/7777/7777 ; my-local-id','2022-08-05 00:26:42','2022-08-05 07:26:42'),(2,1,'ark:/1111/3333','10c','MRT-curatorial','MRT-content','MRT-none',1,'Merritt Team','Hello File','2022','ark:/7777/7777 ; my-local-id','2022-08-05 00:26:43','2022-08-05 07:26:43'),(3,1,'ark:/1111/4444','3f5','MRT-curatorial','MRT-content','MRT-none',1,'Merritt Team','Hello File','2022','ark:/7777/7777 ; my-local-id','2022-08-05 00:26:43','2022-08-05 07:26:43');
INSERT INTO `inv_owners` VALUES (1,NULL,'ark:/99999/owner',NULL);
INSERT INTO `inv_versions` VALUES (1,1,'ark:/1111/2222',1,NULL,'2022-08-05 00:26:42'),(2,2,'ark:/1111/3333',1,NULL,'2022-08-05 00:26:43'),(3,3,'ark:/1111/4444',1,NULL,'2022-08-05 00:26:43');
INSERT INTO `sha_dublinkernels` VALUES (1,'Merritt Team'),(2,'Hello File'),(3,'2022'),(4,'ark:/7777/7777'),(5,'my-local-id'),(6,'Merritt Team'),(7,'Hello File'),(8,'2022'),(9,'ark:/7777/7777'),(10,'my-local-id'),(11,'Merritt Team'),(12,'Hello File'),(13,'2022'),(14,'ark:/7777/7777'),(15,'my-local-id');
