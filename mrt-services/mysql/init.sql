#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
DROP TABLE IF EXISTS `inv_nodes`;
CREATE TABLE `inv_nodes` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `number` int(11) NOT NULL,
  `media_type` enum('magnetic-disk','magnetic-tape','optical-disk','solid-state','unknown') NOT NULL,
  `media_connectivity` enum('cloud','das','nas','san','unknown') NOT NULL,
  `access_mode` enum('on-line','near-line','off-line','unknown') NOT NULL,
  `access_protocol` enum('cifs','nfs','open-stack','s3','zfs','unknown') NOT NULL,
  `node_form` enum('physical','virtual') NOT NULL DEFAULT 'physical',
  `node_protocol` enum('file','http') NOT NULL DEFAULT 'file',
  `logical_volume` varchar(255) DEFAULT NULL,
  `external_provider` varchar(255) DEFAULT NULL,
  `verify_on_read` tinyint(1) NOT NULL,
  `verify_on_write` tinyint(1) NOT NULL,
  `base_url` varchar(2045) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `description` varchar(255) DEFAULT NULL,
  `source_node` smallint(5) unsigned DEFAULT NULL,
  `target_node` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `inv_owners`;
CREATE TABLE `inv_owners` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned DEFAULT NULL,
  `ark` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ark_UNIQUE` (`ark`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_objects`;
CREATE TABLE `inv_objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_owner_id` smallint(5) unsigned NOT NULL,
  `ark` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `md5_3` char(3) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `object_type` enum('MRT-curatorial','MRT-system') COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('MRT-class','MRT-content') COLLATE utf8mb4_unicode_ci NOT NULL,
  `aggregate_role` enum('MRT-collection','MRT-owner','MRT-service-level-agreement','MRT-submission-agreement','MRT-none') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `version_number` smallint(5) unsigned NOT NULL,
  `erc_who` mediumtext COLLATE utf8mb4_unicode_ci,
  `erc_what` mediumtext COLLATE utf8mb4_unicode_ci,
  `erc_when` mediumtext COLLATE utf8mb4_unicode_ci,
  `erc_where` mediumtext COLLATE utf8mb4_unicode_ci,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `modified` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ark_UNIQUE` (`ark`(190)),
  KEY `created` (`created`),
  KEY `modified` (`modified`),
  KEY `id_idx` (`inv_owner_id`),
  CONSTRAINT `inv_objects_ibfk_1` FOREIGN KEY (`inv_owner_id`) REFERENCES `inv_owners` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=89986 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_versions`;
CREATE TABLE `inv_versions` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned NOT NULL,
  `ark` varchar(255) NOT NULL,
  `number` smallint(5) unsigned NOT NULL,
  `note` varchar(16383) DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `created` (`created`),
  KEY `id_idx` (`inv_object_id`),
  KEY `ark` (`ark`),
  CONSTRAINT `inv_versions_ibfk_1` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=141585 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_files`;
CREATE TABLE `inv_files` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned NOT NULL,
  `inv_version_id` int(10) unsigned NOT NULL,
  `pathname` longtext COLLATE utf8mb4_unicode_ci,
  `source` enum('consumer','producer','system') COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('data','metadata') COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_size` bigint(20) unsigned NOT NULL DEFAULT '0',
  `billable_size` bigint(20) unsigned NOT NULL DEFAULT '0',
  `mime_type` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `digest_type` enum('adler-32','crc-32','md2','md5','sha-1','sha-256','sha-384','sha-512') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `digest_value` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `mime_type` (`mime_type`),
  KEY `created` (`created`),
  KEY `id_idx` (`inv_version_id`),
  KEY `id_idx1` (`inv_object_id`),
  KEY `source` (`source`),
  KEY `pathname` (`pathname`(768)),
  KEY `role` (`role`),
  CONSTRAINT `inv_files_ibfk_1` FOREIGN KEY (`inv_version_id`) REFERENCES `inv_versions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_files_ibfk_2` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=2252977 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_audits`;
CREATE TABLE `inv_audits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inv_node_id` smallint(5) unsigned NOT NULL,
  `inv_object_id` int(10) unsigned NOT NULL,
  `inv_version_id` int(10) unsigned NOT NULL,
  `inv_file_id` int(10) unsigned NOT NULL,
  `url` varchar(16383) DEFAULT NULL,
  `status` enum('verified','unverified','size-mismatch','digest-mismatch','system-unavailable','processing','unknown') NOT NULL DEFAULT 'unknown',
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `verified` timestamp NULL DEFAULT NULL,
  `modified` timestamp NULL DEFAULT NULL,
  `failed_size` bigint(20) unsigned NOT NULL DEFAULT '0',
  `failed_digest_value` varchar(255) DEFAULT NULL,
  `note` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inv_node_id` (`inv_node_id`,`inv_version_id`,`inv_file_id`),
  KEY `id_idx` (`inv_node_id`),
  KEY `id_idx1` (`inv_object_id`),
  KEY `id_idx2` (`inv_version_id`),
  KEY `id_idx3` (`inv_file_id`),
  KEY `status` (`status`),
  KEY `verified` (`verified`),
  CONSTRAINT `inv_audits_ibfk_1` FOREIGN KEY (`inv_node_id`) REFERENCES `inv_nodes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_audits_ibfk_2` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_audits_ibfk_3` FOREIGN KEY (`inv_version_id`) REFERENCES `inv_versions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_audits_ibfk_4` FOREIGN KEY (`inv_file_id`) REFERENCES `inv_files` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3261619 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_collections`;
CREATE TABLE `inv_collections` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned DEFAULT NULL,
  `ark` varchar(255) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `mnemonic` varchar(255) DEFAULT NULL,
  `read_privilege` enum('public','restricted') DEFAULT NULL,
  `write_privilege` enum('public','restricted') DEFAULT NULL,
  `download_privilege` enum('public','restricted') DEFAULT NULL,
  `storage_tier` enum('standard','premium') DEFAULT NULL,
  `harvest_privilege` enum('public','none') NOT NULL DEFAULT 'none',
  PRIMARY KEY (`id`),
  UNIQUE KEY `ark_UNIQUE` (`ark`),
  KEY `id_idx` (`inv_object_id`),
  KEY `id_hp` (`harvest_privilege`),
  CONSTRAINT `inv_collections_ibfk_1` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=106 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_collections_inv_nodes`;
CREATE TABLE `inv_collections_inv_nodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inv_collection_id` smallint(5) unsigned NOT NULL,
  `inv_node_id` smallint(5) unsigned NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inv_collection_id` (`inv_collection_id`,`inv_node_id`),
  KEY `id_idx` (`inv_collection_id`),
  KEY `id_idx1` (`inv_node_id`),
  CONSTRAINT `inv_collections_inv_nodes_ibfk_1` FOREIGN KEY (`inv_collection_id`) REFERENCES `inv_collections` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_collections_inv_nodes_ibfk_2` FOREIGN KEY (`inv_node_id`) REFERENCES `inv_nodes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `inv_collections_inv_objects`;
CREATE TABLE `inv_collections_inv_objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_collection_id` smallint(5) unsigned NOT NULL,
  `inv_object_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_idx` (`inv_collection_id`),
  KEY `id_idx1` (`inv_object_id`),
  CONSTRAINT `inv_collections_inv_objects_ibfk_1` FOREIGN KEY (`inv_collection_id`) REFERENCES `inv_collections` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_collections_inv_objects_ibfk_2` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=89688 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_duas`;
CREATE TABLE `inv_duas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_collection_id` smallint(5) unsigned DEFAULT NULL,
  `inv_object_id` int(10) unsigned NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `terms` varchar(16383) NOT NULL,
  `template` text,
  `accept_obligation` enum('required','optional','none') NOT NULL,
  `name_obligation` enum('required','optional','none') NOT NULL,
  `affiliation_obligation` enum('required','optional','none') NOT NULL,
  `email_obligation` enum('required','optional','none') NOT NULL,
  `applicability` enum('collection','object','version','file') NOT NULL,
  `persistence` enum('request','session','permanent') NOT NULL,
  `notification` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_idx` (`inv_collection_id`),
  KEY `id_idx1` (`inv_object_id`),
  KEY `identifier` (`identifier`),
  CONSTRAINT `inv_duas_ibfk_1` FOREIGN KEY (`inv_collection_id`) REFERENCES `inv_collections` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_duas_ibfk_2` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_dublinkernels`;
CREATE TABLE `inv_dublinkernels` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned NOT NULL,
  `inv_version_id` int(10) unsigned NOT NULL,
  `seq_num` smallint(5) unsigned NOT NULL,
  `element` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `qualifier` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id_idx` (`inv_object_id`),
  KEY `id_idx1` (`inv_version_id`),
  CONSTRAINT `inv_dublinkernels_ibfk_1` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_dublinkernels_ibfk_2` FOREIGN KEY (`inv_version_id`) REFERENCES `inv_versions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=707731 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_embargoes`;
CREATE TABLE `inv_embargoes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned NOT NULL,
  `embargo_end_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inv_object_id_UNIQUE` (`inv_object_id`),
  KEY `embargo_end_date` (`embargo_end_date`),
  CONSTRAINT `inv_embargoes_ibfk_1` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=1397 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `inv_ingests`;
CREATE TABLE `inv_ingests` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned NOT NULL,
  `inv_version_id` int(10) unsigned NOT NULL,
  `filename` varchar(255) NOT NULL,
  `ingest_type` enum('file','container','object-manifest','single-file-batch-manifest','container-batch-manifest','batch-manifest') NOT NULL,
  `profile` varchar(255) NOT NULL,
  `batch_id` varchar(255) NOT NULL,
  `job_id` varchar(255) NOT NULL,
  `user_agent` varchar(255) DEFAULT NULL,
  `submitted` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `storage_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `id_idx` (`inv_object_id`),
  KEY `id_idx1` (`inv_version_id`),
  KEY `profile` (`profile`),
  KEY `batch_id` (`batch_id`),
  KEY `user_agent` (`user_agent`),
  KEY `submitted` (`submitted`),
  CONSTRAINT `inv_ingests_ibfk_1` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_ingests_ibfk_2` FOREIGN KEY (`inv_version_id`) REFERENCES `inv_versions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=141538 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_localids`;
CREATE TABLE `inv_localids` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inv_object_ark` varchar(255) NOT NULL,
  `inv_owner_ark` varchar(255) NOT NULL,
  `local_id` varchar(255) NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `loc_unique` (`inv_owner_ark`,`local_id`),
  KEY `id_idoba` (`inv_object_ark`),
  KEY `id_idowa` (`inv_owner_ark`),
  KEY `id_idloc` (`local_id`)
) ENGINE=InnoDB AUTO_INCREMENT=81013 DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

DROP TABLE IF EXISTS `inv_metadatas`;
CREATE TABLE `inv_metadatas` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `inv_object_id` int(10) unsigned NOT NULL,
  `inv_version_id` int(10) unsigned NOT NULL,
  `filename` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `md_schema` enum('DataCite','DublinCore','CSDGM','EML','OAI_DublinCore','StashWrapper') COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `serialization` enum('anvl','json','xml') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`id`),
  KEY `id_idx` (`inv_object_id`),
  KEY `id_idx1` (`inv_version_id`),
  KEY `id_metax` (`version`(191)),
  CONSTRAINT `inv_metadatas_ibfk_1` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_metadatas_ibfk_2` FOREIGN KEY (`inv_version_id`) REFERENCES `inv_versions` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=37508 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DROP TABLE IF EXISTS `inv_nodes_inv_objects`;
CREATE TABLE `inv_nodes_inv_objects` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `inv_node_id` smallint(5) unsigned NOT NULL,
  `inv_object_id` int(10) unsigned NOT NULL,
  `role` enum('primary','secondary') NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `replicated` timestamp NULL DEFAULT NULL,
  `version_number` smallint(5) unsigned DEFAULT NULL,
  replic_start timestamp null,
  replic_size bigint null,
  completion_status ENUM('ok', 'fail', 'partial', 'unknown') NULL,
  note mediumtext null,
  PRIMARY KEY (`id`),
  UNIQUE KEY `inv_object_id` (`inv_object_id`,`inv_node_id`),
  KEY `id_idx` (`inv_node_id`),
  KEY `id_idx1` (`inv_object_id`),
  KEY `id_idx2` (`replicated`),
  key `irep_start` (`replic_start`),
  key `irep_size` (`replic_size`),
  key `irep_status` (`completion_status`),
  CONSTRAINT `inv_nodes_inv_objects_ibfk_1` FOREIGN KEY (`inv_node_id`) REFERENCES `inv_nodes` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `inv_nodes_inv_objects_ibfk_2` FOREIGN KEY (`inv_object_id`) REFERENCES `inv_objects` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=230624 DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sha_dublinkernels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sha_dublinkernels` (
  `id` int(10) unsigned NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  FULLTEXT KEY `value` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;

CREATE TABLE `inv_storage_maints` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`inv_storage_scan_id` INT(10) NOT NULL,
	`inv_node_id` SMALLINT(5) UNSIGNED NOT NULL,
	`keymd5` CHAR(32) NOT NULL COLLATE 'utf8_general_ci',
	`size` BIGINT(20) UNSIGNED NOT NULL DEFAULT '0',
	`file_created` TIMESTAMP NULL DEFAULT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`file_removed` TIMESTAMP NULL DEFAULT NULL,
	`maint_status` ENUM(
            'review',
            'hold',
            'delete',
            'removed',
            'note',
            'error',
            'unknown'
            ) NOT NULL DEFAULT 'unknown',
	`maint_type` ENUM(
            'non-ark',
            'missing-ark',
            'orphan-copy',
            'missing-file',
            'unknown'
            ) NOT NULL DEFAULT 'unknown',
	`s3key` MEDIUMTEXT NOT NULL,
	`note` MEDIUMTEXT not NULL,
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `keymd5_idx` (`inv_node_id`, `keymd5`) USING BTREE,
	INDEX `type_idx` (`maint_type`) USING BTREE,
	INDEX `status_idx` (`maint_status`) USING BTREE,
	CONSTRAINT `inv_scans_ibfk_2` FOREIGN KEY (`inv_node_id`) REFERENCES `inv_nodes` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;

CREATE TABLE `inv_storage_scans` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`inv_node_id` SMALLINT(5) UNSIGNED NOT NULL,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`scan_status` ENUM(
            'pending',
            'started',
            'completed',
            'cancelled',
            'failed',
            'unknown'
            ) NOT NULL DEFAULT 'unknown' COLLATE 'utf8mb4_general_ci',
	`scan_type` ENUM(
            'list',
            'next',
            'delete',
            'build',
            'unknown'
            ) NOT NULL DEFAULT 'unknown' COLLATE 'utf8mb4_general_ci',
	`keys_processed` BIGINT(20) NOT NULL DEFAULT '0',
	`key_list_name` VARCHAR(255) NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	`last_s3_key` MEDIUMTEXT NOT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`) USING BTREE,
	INDEX `scan_type_idx` (`scan_type`) USING BTREE,
	INDEX `scan_status_idx` (`scan_status`) USING BTREE,
	INDEX `inv_scans_node_id_ibfk_3` (`inv_node_id`) USING BTREE,
	CONSTRAINT `inv_scans_node_id_ibfk_3` FOREIGN KEY (`inv_node_id`) REFERENCES `inv_nodes` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;

#CREATE USER user@'%';
GRANT ALL ON *.* to 'user'@'%';

CREATE USER travis@'%';
GRANT ALL ON *.* to 'travis'@'%';

ALTER USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';

flush privileges;

# Triggers

DELIMITER //
DROP TRIGGER IF EXISTS insert_fulltext//
CREATE TRIGGER insert_fulltext
AFTER INSERT ON inv_dublinkernels
FOR EACH ROW
BEGIN
  IF NOT NEW.value='(:unas)' THEN
    INSERT INTO sha_dublinkernels
    VALUES (NEW.id, NEW.value);
  END IF;
END;
//
DROP TRIGGER IF EXISTS update_fulltext//
CREATE TRIGGER update_fulltext
AFTER UPDATE ON inv_dublinkernels
FOR EACH ROW
BEGIN
  IF NEW.value!='(:unas)' THEN
    UPDATE sha_dublinkernels
    SET value = NEW.value
    WHERE id = NEW.id;
  END IF;
END;
//
DROP TRIGGER IF EXISTS delete_fulltext//
CREATE TRIGGER delete_fulltext
AFTER DELETE ON inv_dublinkernels
FOR EACH ROW
BEGIN
  DELETE FROM sha_dublinkernels
  WHERE id = OLD.id;
END;
//
DELIMITER ;
insert into sha_dublinkernels 
select id, value from inv_dublinkernels 
where not inv_dublinkernels.element='where' 
and not inv_dublinkernels.value='(:unas)';

# Configure content

insert into inv_collections(ark,name,mnemonic,harvest_privilege)
select 'ark:/13030/j2cc0900','Merritt owners',null, 'none'
union
select 'ark:/13030/j2h41690','Merritt service level agreements',null,'none'
union
select 'ark:/13030/j27p88qw','Merritt curatorial classes','mrt_curatorial_classes','none'
union
select 'ark:/13030/j2mw23mp','Merritt system classes','mrt_system_classes','none'
union
select 'ark:/13030/m5rn35s8','demo','merritt_demo','public'
union
select 'ark:/13030/m5qv8jks','cdl_dryaddev','cdl_dryaddev','public' 
union
select 'ark:/13030/m5154f09','escholarship','escholarship','none';

insert into inv_owners(ark, name)
select 'ark:/13030/j2rn30xp', 'UC3 Merritt administrator';

insert into inv_nodes(
  number,
  media_type,
  media_connectivity,
  access_mode,
  access_protocol,
  node_form,
  node_protocol,
  logical_volume,
  external_provider,
  verify_on_read,
  verify_on_write,
  base_url
)
select
  7777,
  'magnetic-disk',
  'cloud',
  'on-line',
  's3',
  'physical',
  'http',
  'yaml:7777',
  'nodeio',
  1,
  1,
  'http://store:8080/store'
union
select
  8888,
  'magnetic-disk',
  'cloud',
  'on-line',
  's3',
  'physical',
  'http',
  'yaml:|8888',
  'nodeio',
  1,
  1,
  'http://store:8080/store'
;

insert into inv_collections_inv_nodes(inv_collection_id, inv_node_id)
select 
  (select id from inv_collections where name='demo'),
  (select id from inv_nodes where number='8888')
;