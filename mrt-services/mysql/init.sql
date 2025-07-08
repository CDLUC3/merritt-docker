create database inv CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

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

CREATE TABLE `inv_tasks` (
	`id` INT(10) NOT NULL AUTO_INCREMENT,
	`created` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`updated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`task_name` VARCHAR(255) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`task_item` VARCHAR(511) NOT NULL COLLATE 'utf8mb4_unicode_ci',
	`retries` INT(10) NOT NULL DEFAULT '0',
	`current_status` ENUM('ok','fail','pending','partial','unknown') NOT NULL DEFAULT 'unknown' COLLATE 'utf8mb4_unicode_ci',
	`note` MEDIUMTEXT NULL DEFAULT NULL COLLATE 'utf8mb4_unicode_ci',
	PRIMARY KEY (`id`) USING BTREE,
	UNIQUE INDEX `inx_tasks` (`task_name`, `task_item`) USING BTREE,
	INDEX `updated_inx` (`updated`) USING BTREE,
	INDEX `task_name_inx` (`task_name`) USING BTREE,
	INDEX `task_item_inx` (`task_item`) USING BTREE,
	INDEX `status_inx` (`current_status`) USING BTREE
)
COLLATE='utf8mb4_unicode_ci'
ENGINE=InnoDB
ROW_FORMAT=DYNAMIC
;

#CREATE USER user@'%';
GRANT ALL ON *.* to 'user'@'%';

CREATE USER travis@'%';
GRANT ALL ON *.* to 'travis'@'%';

ALTER USER 'user'@'%' IDENTIFIED WITH caching_sha2_password BY 'password';

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

insert into inv_owners(ark, name)
select 'ark:/13030/j2rn30xp', 'UC3 Merritt administrator';

insert into inv_objects(inv_owner_id, ark, version_number, object_type, role, aggregate_role)
select (select max(id) from inv_owners), 'ark:/13030/m5rn35s8', 1, 'MRT-curatorial','MRT-class','MRT-collection'
union
select (select max(id) from inv_owners), 'ark:/13030/m5qv8jks', 1, 'MRT-curatorial','MRT-class','MRT-collection'
union
select (select max(id) from inv_owners), 'ark:/13030/m5154f09', 1, 'MRT-curatorial','MRT-class','MRT-collection'
;

insert into inv_collections(ark,name,mnemonic,harvest_privilege, inv_object_id)
select 'ark:/13030/j2cc0900','Merritt owners',null, 'none', null
union
select 'ark:/13030/j2h41690','Merritt service level agreements',null,'none', null
union
select 'ark:/13030/j27p88qw','Merritt curatorial classes','mrt_curatorial_classes','none', null
union
select 'ark:/13030/j2mw23mp','Merritt system classes','mrt_system_classes','none', null
union
select 'ark:/13030/m5rn35s8','demo','merritt_demo','public', (select id from inv_objects where ark='ark:/13030/m5rn35s8') 
union
select 'ark:/13030/m5qv8jks','cdl_dryaddev','cdl_dryaddev','public' , (select id from inv_objects where ark='ark:/13030/m5qv8jks')
union
select 'ark:/13030/m5154f09','escholarship','escholarship','none', (select id from inv_objects where ark='ark:/13030/m5154f09')
;


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

create database billing CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
use billing;

/*
   This table replicates the CSV files generated once per day in the old Merritt Billing process.
   Records will be added to this table based on the inv.inv_files.created field.
 */
/*
DROP TABLE IF EXISTS daily_billing;
*/
CREATE TABLE daily_billing (
  id int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  billing_totals_date date,
  inv_owner_id smallint unsigned,
  inv_collection_id smallint unsigned not null,
  billable_size bigint unsigned NOT NULL DEFAULT '0',
  INDEX billing_totals_date (billing_totals_date),
  UNIQUE INDEX collection_daily (billing_totals_date, inv_collection_id, inv_owner_id),
  INDEX inv_owner_id (inv_owner_id),
  INDEX inv_collection_id (inv_collection_id)
);

/*
   This table is designed to optimized mime_type reporting in the Merritt Admin tool.
   Records will be added to this table based on the inv.inv_files.created field.
 */
/* 
DROP TABLE IF EXISTS daily_mime_use_details;
*/
CREATE TABLE daily_mime_use_details (
  date_added date,
  mime_type varchar(255) collate 'utf8mb4_unicode_ci',
  inv_owner_id int,
  inv_collection_id int,
  source enum('consumer','producer','system'),
  count_files bigint,
  full_size bigint,
  billable_size bigint,
  INDEX date_added(date_added),
  INDEX mime_type(mime_type),
  INDEX collection_id(inv_collection_id),
  INDEX owner_id(inv_owner_id),
  UNIQUE INDEX daily(date_added, mime_type, inv_collection_id, inv_owner_id, source)
) default charset utf8mb4 default collate 'utf8mb4_unicode_ci';

/*
DROP TABLE IF EXISTS billing_owner_exemptions;
*/
CREATE TABLE billing_owner_exemptions (
  inv_owner_id int,
  exempt_bytes bigint
);

/*
DROP TABLE IF EXISTS object_size;
*/
CREATE TABLE object_size (
  inv_object_id int,
  file_count bigint,
  billable_size bigint,
  max_size bigint,
  average_size bigint,
  updated datetime,
  INDEX object_id(inv_object_id)
);

/*
ALTER TABLE object_size add column max_size bigint;
ALTER TABLE object_size add column average_size bigint;
update 
  object_size 
set
  max_size = (select max(billable_size) from inv.inv_files where inv_object_id=object_size.inv_object_id),
  average_size = (select avg(billable_size) from inv.inv_files where inv_object_id=object_size.inv_object_id and billable_size = full_size)
where
  max_size is null
and exists (select 1 from inv.inv_objects o where object_size.inv_object_id = o.id)
limit 
  10;
*/

/*
DROP TABLE IF EXISTS audits_processed;
*/
CREATE TABLE audits_processed (
  audit_date date,
  all_files bigint,
  online_files bigint,
  online_bytes bigint,
  s3_files bigint,
  s3_bytes bigint,
  glacier_files bigint,
  glacier_bytes bigint,
  sdsc_files bigint,
  sdsc_bytes bigint,
  wasabi_files bigint,
  wasabi_bytes bigint,
  other_files bigint,
  other_bytes bigint,
  INDEX audit_date(audit_date)
);

/*
DROP TABLE IF EXISTS ingests_completed;
*/
CREATE TABLE ingests_completed (
  ingest_date date,
  profile varchar(255), 
  batch_id varchar(255),
  object_count int, 
  INDEX ingest_date(ingest_date)
);
  

/*
DROP TABLE IF EXISTS daily_node_counts;
*/
CREATE TABLE daily_node_counts (
  as_of_date date,
  inv_node_id int,
  number int,
  object_count bigint,
  object_count_primary bigint,
  object_count_secondary bigint,
  file_count bigint,
  billable_size bigint,
  index node_id(inv_node_id),
  INDEX as_of_date(as_of_date)
);

/*
DROP TABLE IF EXISTS object_health_json;
*/
CREATE TABLE object_health_json (
  inv_object_id int,
  updated datetime default now(),
  object_health json,
  UNIQUE INDEX object_id(inv_object_id)
);

/*
DROP TABLE IF EXISTS daily_consistency_checks;
*/
CREATE TABLE daily_consistency_checks (
  check_name varchar(255),
  updated datetime default now(),
  status enum('PASS', 'INFO', 'WARN', 'FAIL', 'SKIP'),
  index check_name(check_name),
  index check_name_updated(check_name, updated)
);

/*
  Roll up Merritt Owner objects to each campus + CDL.
  Other views will re-use this mapping.
 */
drop view if exists owner_list;
create view owner_list as
  select distinct
    CASE
      WHEN own.name REGEXP '^(CDL|UC3)' THEN 'CDL'
      WHEN own.name REGEXP '(^UCB |Berkeley)' THEN 'UCB'
      WHEN own.name REGEXP '(^UCD)' THEN 'UCD'
      WHEN own.name REGEXP '(^UCLA)' THEN 'UCLA'
      WHEN own.name REGEXP '(^UCSB)' THEN 'UCSB'
      WHEN own.name REGEXP '(^UCI)' THEN 'UCI'
      WHEN own.name REGEXP '(^UCM)' THEN 'UCM'
      WHEN own.name REGEXP '(^UCR)' THEN 'UCR'
      WHEN own.name REGEXP '(^UCSC)' THEN 'UCSC'
      WHEN own.name REGEXP '(^UCSD)' THEN 'UCSD'
      WHEN own.name REGEXP '(^UCSF)' THEN 'UCSF'
      ELSE 'Other'
    END as ogroup,
    CASE
      WHEN own.name is null and own.id = 42 THEN 'Dryad'
      WHEN own.name is null THEN '(No name specified)'
      ELSE own.name
    END as own_name,
    own.id as inv_owner_id
  from
    inv.inv_owners own
;

/*
  Roll up mime types into logical groupings reported to the Digital Preservation working group.
  By default, the first part of the mime type will be used as a grouping.
  Regular expressions are applied first in order to handle excpetion types.
  Other views will re-use this mapping.
 */
drop view if exists owner_coll_mime_use_details;
create view owner_coll_mime_use_details as
  select
    ol.ogroup,
    ol.own_name,
    c.name as collection_name,
    c.mnemonic,
    dmud.date_added,
    dmud.mime_type,
    CASE
      WHEN mime_type = 'text/csv' THEN 'data'
      WHEN mime_type = 'plain/turtle' THEN 'data'
      WHEN mime_type REGEXP '^application/(json|atom\.xml|marc|mathematica|x-hdf|x-matlab-data|x-sas|x-sh$|x-sqlite|x-stata)' THEN 'data'
      WHEN mime_type REGEXP '^application/.*(zip|gzip|tar|compress|zlib)' THEN 'container'
      WHEN mime_type REGEXP '^application/(x-font|x-web)' THEN 'web'
      WHEN mime_type REGEXP '^application/(x-dbf|vnd\.google-earth)' THEN 'geo'
      WHEN mime_type REGEXP '^application/vnd\.(rn-real|chipnuts)' THEN 'audio'
      WHEN mime_type REGEXP '^application/mxf' THEN 'video'
      WHEN mime_type REGEXP '^(message|model)/' THEN 'text'
      WHEN mime_type REGEXP '^(multipart|text/x-|application/java|application/x-executable|application/x-shockwave-flash)' THEN 'software'
      WHEN mime_type REGEXP '^application/' THEN 'text'
      ELSE substring_index(mime_type, '/', 1)
    END as mime_group,
    dmud.inv_owner_id,
    dmud.inv_collection_id,
    dmud.source,
    dmud.count_files,
    dmud.full_size,
    dmud.billable_size
  from
    owner_list ol
  inner join daily_mime_use_details dmud
    on dmud.inv_owner_id = ol.inv_owner_id
  inner join inv.inv_collections c
    on c.id = dmud.inv_collection_id
  inner join inv.inv_objects o 
    on c.inv_object_id = o.id and o.aggregate_role = 'MRT-collection'
;

/*
  Aggregate mime type usage by owner and collection
 */
drop view if exists mime_use_details;
create view mime_use_details as
select
  mime_type,
  mime_group,
  inv_owner_id,
  inv_collection_id,
  source,
  sum(count_files) as count_files,
  sum(full_size) as full_size,
  sum(billable_size) as billable_size
from
  owner_coll_mime_use_details
group by
  mime_type,
  mime_group,
  inv_owner_id,
  inv_collection_id,
  source
;

/*
  Aggregate mime type usage by campus. Also include collection name.
 */
drop view if exists owner_collections;
create view owner_collections as
  select distinct
    dmud.ogroup,
    dmud.own_name,
    c.name as collection_name,
    c.mnemonic,
    dmud.inv_owner_id,
    dmud.inv_collection_id
  from
    inv.inv_collections c
  inner join owner_coll_mime_use_details dmud
    on dmud.inv_collection_id = c.id
;


/*
  Aggregate object counts by campus, owner and collection.
 */
drop view if exists owner_collections_objects;
create view owner_collections_objects as
  select
    ol.ogroup,
    ol.own_name as own_name,
    c.name as collection_name,
    ol.inv_owner_id,
    c.id as inv_collection_id,
    count(o.id) count_objects
  from
    inv.inv_collections c
  inner join inv.inv_objects o2
    on c.inv_object_id = o2.id and o2.aggregate_role = 'MRT-collection'
  inner join inv.inv_collections_inv_objects icio
    on c.id = icio.inv_collection_id
  inner join inv.inv_objects o
    on o.id = icio.inv_object_id
  inner join owner_list ol
    on o.inv_owner_id = ol.inv_owner_id
  group by
    ogroup,
    collection_name,
    inv_owner_id,
    inv_collection_id
;

drop view if exists node_counts;
create view node_counts as
  select
    inv_node_id,
    number,
    object_count,
    object_count_primary,
    object_count_secondary,
    file_count,
    billable_size
  from 
    daily_node_counts
  where
    as_of_date = (
      select
        max(as_of_date)
      from 
        daily_node_counts
    )
;

DELIMITER $$

/*
  Delete a range of daily records from the billing database.
  This procedure is only needed when troubleshooting a range of records.

  call clear_range('2013-05-22', '2013-05-23');
 */
DROP PROCEDURE IF EXISTS clear_range$$
CREATE PROCEDURE clear_range(dstart date, dend date)
BEGIN
  delete from
    daily_mime_use_details
  where
    date_added >= dstart and date_added < dend
  ;

  delete from
    daily_billing
  where
    billing_totals_date >= dstart and billing_totals_date < dend
  ;
END$$

DELIMITER $$


/*
  Pull a range of records into the daily_mime_use_details table.

  If a record already exists for a date/mime/owner/collection/source, a new record will not be inserted.
  This will allow missing records to be inserted over a range of dates.

  This should not be called directly.  This procedure is called by iterate_range.
 */
DROP PROCEDURE IF EXISTS pull_range$$
CREATE PROCEDURE pull_range(dstart date, dend date)
BEGIN
  insert into daily_mime_use_details(
    date_added,
    mime_type,
    inv_owner_id,
    inv_collection_id,
    source,
    count_files,
    full_size,
    billable_size
  )
  select
    date(f.created) as date_added,
    f.mime_type,
    o.inv_owner_id,
    icio.inv_collection_id,
    f.source,
    count(f.id),
    sum(f.full_size),
    sum(f.billable_size)
  from
    inv.inv_files f
  inner join inv.inv_collections_inv_objects icio
    on icio.inv_object_id = f.inv_object_id
  inner join inv.inv_objects o
    on o.id = f.inv_object_id
  where
    f.created >= dstart and f.created < dend
  and not exists (
    select 1
    from
      daily_mime_use_details dmud
    where
      dmud.date_added = date(f.created)
    and
      dmud.mime_type = f.mime_type
    and
      dmud.inv_owner_id = o.inv_owner_id
    and
      dmud.inv_collection_id = icio.inv_collection_id
    and
      dmud.source = f.source
  )
  group by
    date_added,
    icio.inv_collection_id,
    o.inv_owner_id,
    f.mime_type,
    f.source
  ;
END$$

DELIMITER $$

/*
  Pull a range of records into the daily_billing table.

  If a record already exists for a date/owner/collection, a new record will not be inserted.
  This will allow missing records to be inserted over a range of dates.

  This should not be called directly.  This procedure is called by iterate_range.
 */
DROP PROCEDURE IF EXISTS billing_day$$
CREATE PROCEDURE billing_day(dstart date)
BEGIN
  insert into daily_billing(
    billing_totals_date,
    inv_owner_id,
    inv_collection_id,
    billable_size
  )
  select
    dstart,
    inv_owner_id,
    inv_collection_id,
    sum(billable_size)
  from
    daily_mime_use_details dmud
  where
    date_added <= dstart
  and not exists (
    select 1
    from
      daily_billing db
    where
      db.billing_totals_date = dstart
    and
      db.inv_owner_id = dmud.inv_owner_id
    and
      db.inv_collection_id = dmud.inv_collection_id
  )
  group by
    dstart,
    inv_owner_id,
    inv_collection_id
  ;
END$$

DELIMITER $$

/*
  Pull a range of records into the daily_billing and daily_mime_use_details tables.

  Records will be pulled day by day to keep the transactions efficient.

  call iterate_range('2013-05-22', '2013-05-23');
 */
DROP PROCEDURE IF EXISTS iterate_range$$
CREATE PROCEDURE iterate_range(dstart date, dend date)
BEGIN
  if dend > dstart then
    set @dcur = dstart;
    loop_label: LOOP
      set @dnext = adddate(@dcur, interval 1 day);

      call pull_range(@dcur, @dnext);
      call billing_day(@dcur);

      set @dcur = @dnext;
      if @dcur >= dend then
        LEAVE loop_label;
      end if;
    END LOOP;
  end if;
END$$

DELIMITER $$

DROP PROCEDURE IF EXISTS update_billing_range$$
CREATE PROCEDURE update_billing_range()
BEGIN
  call iterate_range(
    (
      select
        date_add(max(billing_totals_date), interval 1 day)
      from
        daily_billing
    ),
    date(now())
  );
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS update_object_size$$
CREATE PROCEDURE update_object_size()
BEGIN

  select
    ifnull(max(updated), '2013-01-01')
  into
    @lastupdated
  from
    object_size
  ;

  delete from
    object_size
  where exists (
    select
      1
    from
      inv.inv_objects o
    where
      o.id = object_size.inv_object_id
    and
      o.modified > @lastupdated
  );

  insert into
    object_size(
      inv_object_id, 
      file_count, 
      billable_size, 
      max_size, 
      average_size,
      updated
    )
  select
    inv_object_id,
    count(*) as file_count,
    sum(billable_size) as billable_size,
    max(billable_size) as max_size,
    avg(billable_size) as average_size,
    now()
  from
    inv.inv_files f
  inner join inv.inv_objects o
    on o.id = f.inv_object_id
  where
    f.billable_size = f.full_size
  and
    o.modified > @lastupdated
  group by
    inv_object_id
  ;
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS update_node_counts$$
CREATE PROCEDURE update_node_counts()
BEGIN
  delete from 
    daily_node_counts 
  where 
    as_of_date = date(now());
  insert into daily_node_counts (
    as_of_date,
    inv_node_id,
    number,
    object_count,
    object_count_primary,
    object_count_secondary,
    file_count,
    billable_size
  )
  select
    date(now()),
    n.id,
    n.number,
    count(inio.inv_object_id),
    sum(case when role ='primary' then 1 else 0 end),
    sum(case when role ='secondary' then 1 else 0 end),
    sum(os.file_count),
    sum(os.billable_size)
  from
    inv.inv_nodes n
  inner join inv.inv_nodes_inv_objects inio 
    on n.id = inio.inv_node_id
  inner join object_size os
    on inio.inv_object_id = os.inv_object_id
  group by 
    n.id,
    n.number
  ;
END$$

DELIMITER ;

DELIMITER $$

/*
 */
DROP PROCEDURE IF EXISTS iterate_audit_range$$
CREATE PROCEDURE iterate_audit_range(dstart date, dend date)
BEGIN
  if dend > dstart then
    set @dcur = dstart;
    loop_label: LOOP
      set @dnext = adddate(@dcur, interval 1 day);

      call update_audits_processed_for_day(@dcur);

      set @dcur = @dnext;
      if @dcur >= dend then
        LEAVE loop_label;
      end if;
    END LOOP;
  end if;
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS update_audits_processed$$
CREATE PROCEDURE update_audits_processed()
BEGIN
  call iterate_audit_range(
    (
      select 
        date_add(max(audit_date), INTERVAL 1 DAY) 
      from 
        audits_processed
    ),
    date(now())
  );
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS update_audits_processed_for_day$$
CREATE PROCEDURE update_audits_processed_for_day(dcur date)
BEGIN
  set @dcur = dcur;
  delete from
    audits_processed
  where 
    audit_date = @dcur;

  CREATE TEMPORARY TABLE IF NOT EXISTS tmp_audits_processed AS (
    select * from audits_processed limit 0
  );

  truncate table tmp_audits_processed;

  set @interval = 5,
      @tstart = date_add(@dcur, INTERVAL 0 HOUR),
      @tnext = date_add(@tstart, INTERVAL @interval MINUTE),
      @tend = date_add(@dcur, INTERVAL 1 DAY);

  loop_label: LOOP
    insert into 
      tmp_audits_processed
    select
      @dcur as audit_date,
      count(a.id) as all_files,
      ifnull(
        sum(
          case 
            when a.inv_node_id in (select id from inv.inv_nodes where access_mode != 'on-line') 
              then 0
            else 1
          end
        ), 
        0
      ) as online_files,
      ifnull(
        sum(
          case 
            when a.inv_node_id in (select id from inv.inv_nodes where access_mode != 'on-line') 
              then 0
            else full_size
          end
        ), 
        0
      ) as online_bytes,
      ifnull(
        sum(
          case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (5001, 3041, 3042)) 
                then 1
            else 0
            end
        ), 
        0
        ) as s3_files,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (5001, 3041, 3042)) 
                then full_size
            else 0
            end
        ), 
        0
        ) as s3_bytes,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where access_mode != 'on-line') 
                then 1
            else 0
            end
        ), 
        0
        ) as glacier_files,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where access_mode != 'on-line') 
                then full_size
            else 0
            end
        ), 
        0
        ) as glacier_bytes,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (2001, 2002)) 
                then 1
            else 0
            end
        ), 
        0
        ) as sdsc_files,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (2001, 2002)) 
                then full_size
            else 0
            end
        ), 
        0
        ) as sdsc_bytes,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (9501, 9502)) 
                then 1
            else 0
            end
        ), 
        0
        ) as wasabi_files,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (9501, 9502)) 
                then full_size
            else 0
            end
        ), 
        0
        ) as wasabi_bytes,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (5001, 3041, 3042)) 
                then 0
            when a.inv_node_id in (select id from inv.inv_nodes where access_mode != 'on-line') 
                then 0
            when a.inv_node_id in (select id from inv.inv_nodes where number in (2001, 2002)) 
                then 0
            when a.inv_node_id in (select id from inv.inv_nodes where number in (9501, 9502)) 
                then 0
            else 1
            end
        ), 
        0
        ) as other_files,
        ifnull(
        sum(
            case 
            when a.inv_node_id in (select id from inv.inv_nodes where number in (5001, 3041, 3042)) 
                then 0
            when a.inv_node_id in (select id from inv.inv_nodes where access_mode != 'on-line') 
                then 0
            when a.inv_node_id in (select id from inv.inv_nodes where number in (2001, 2002)) 
                then 0
            when a.inv_node_id in (select id from inv.inv_nodes where number in (9501, 9502)) 
                then 0
            else full_size
            end
        ), 
        0
        ) as other_bytes
    from
        inv.inv_audits a
    inner join inv.inv_files f
        on 
        f.id = a.inv_file_id
        and 
        f.inv_object_id = a.inv_object_id
        and
        f.inv_version_id = a.inv_version_id
    where
        verified >= @tstart
    and
        verified < @tnext
    ;

    set @tstart = @tnext,
        @tnext = date_add(@tstart, INTERVAL @interval MINUTE);

    if @tstart >= @tend then
      LEAVE loop_label;
    end if;
  END LOOP;

  insert into audits_processed
  select
    audit_date,
    sum(all_files),
    sum(online_files),
    sum(online_bytes),
    sum(s3_files),
    sum(s3_bytes),
    sum(glacier_files),
    sum(glacier_bytes),
    sum(sdsc_files),
    sum(sdsc_bytes),
    sum(wasabi_files),
    sum(wasabi_bytes),
    sum(other_files),
    sum(other_bytes)
   from 
     tmp_audits_processed
   group by
     audit_date;

END$$

DELIMITER ;

DELIMITER $$

/*
 */
DROP PROCEDURE IF EXISTS iterate_ingest_range$$
CREATE PROCEDURE iterate_ingest_range(dstart date, dend date)
BEGIN
  if dend > dstart then
    set @dcur = dstart;
    loop_label: LOOP
      set @dnext = adddate(@dcur, interval 1 day);

      call update_ingests_processed_for_day(@dcur);

      set @dcur = @dnext;
      if @dcur >= dend then
        LEAVE loop_label;
      end if;
    END LOOP;
  end if;
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS update_ingests_processed$$
CREATE PROCEDURE update_ingests_processed()
BEGIN
  call iterate_ingest_range(
    (
      select 
        date_add(max(ingest_date), INTERVAL 1 DAY) 
      from 
        ingests_completed
    ), 
    date(now())
  );
END$$

DELIMITER ;

DELIMITER $$

DROP PROCEDURE IF EXISTS update_ingests_processed_for_day$$
CREATE PROCEDURE update_ingests_processed_for_day(dcur date)
BEGIN
  set @dcur = dcur;
  delete from
    ingests_completed
  where 
    ingest_date = @dcur;

  insert into 
    ingests_completed
  select
    date(max(submitted)) as ingest_date,
    profile, 
    batch_id, 
    count(*) 
  from 
    inv.inv_ingests 
  where 
    date(submitted) = @dcur
  group by 
    profile, 
    batch_id
  order by 
    date(max(submitted)) desc
  ;

END$$

DELIMITER ;

GRANT ALL ON *.* to 'user'@'%';
 
