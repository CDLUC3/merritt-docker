-- MySQL dump 10.14  Distrib 5.5.60-MariaDB, for Linux (x86_64)
--
-- Host: localhost    Database: da_ca
-- ------------------------------------------------------
-- Server version	5.5.60-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ca_acl`
--

DROP TABLE IF EXISTS `ca_acl`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_acl` (
  `acl_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `notes` char(10) NOT NULL,
  `inherited_from_table_num` tinyint(3) unsigned DEFAULT NULL,
  `inherited_from_row_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`acl_id`),
  KEY `i_row_id` (`row_id`,`table_num`),
  KEY `i_user_id` (`user_id`),
  KEY `i_group_id` (`group_id`),
  KEY `i_inherited_from_table_num` (`inherited_from_table_num`),
  KEY `i_inherited_from_row_id` (`inherited_from_row_id`),
  CONSTRAINT `fk_ca_acl_group_id` FOREIGN KEY (`group_id`) REFERENCES `ca_user_groups` (`group_id`),
  CONSTRAINT `fk_ca_acl_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_acl`
--

LOCK TABLES `ca_acl` WRITE;
/*!40000 ALTER TABLE `ca_acl` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_acl` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_application_vars`
--

DROP TABLE IF EXISTS `ca_application_vars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_application_vars` (
  `vars` longtext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_application_vars`
--

LOCK TABLES `ca_application_vars` WRITE;
/*!40000 ALTER TABLE `ca_application_vars` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_application_vars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_attribute_value_multifiles`
--

DROP TABLE IF EXISTS `ca_attribute_value_multifiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_attribute_value_multifiles` (
  `multifile_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `value_id` int(10) unsigned NOT NULL,
  `resource_path` text NOT NULL,
  `media` longblob NOT NULL,
  `media_metadata` longblob NOT NULL,
  `media_content` longtext NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`multifile_id`),
  KEY `i_resource_path` (`resource_path`(255)),
  KEY `i_value_id` (`value_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_attribute_value_multifiles`
--

LOCK TABLES `ca_attribute_value_multifiles` WRITE;
/*!40000 ALTER TABLE `ca_attribute_value_multifiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_attribute_value_multifiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_attribute_values`
--

DROP TABLE IF EXISTS `ca_attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_attribute_values` (
  `value_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `element_id` smallint(5) unsigned NOT NULL,
  `attribute_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned DEFAULT NULL,
  `value_longtext1` longtext,
  `value_longtext2` longtext,
  `value_blob` longblob,
  `value_decimal1` decimal(40,20) DEFAULT NULL,
  `value_decimal2` decimal(40,20) DEFAULT NULL,
  `value_integer1` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  PRIMARY KEY (`value_id`),
  KEY `i_element_id` (`element_id`),
  KEY `i_attribute_id` (`attribute_id`),
  KEY `i_value_integer1` (`value_integer1`),
  KEY `i_value_decimal1` (`value_decimal1`),
  KEY `i_value_decimal2` (`value_decimal2`),
  KEY `i_item_id` (`item_id`),
  KEY `i_value_longtext1` (`value_longtext1`(128)),
  KEY `i_value_longtext2` (`value_longtext2`(128)),
  KEY `i_source_info` (`source_info`(255)),
  KEY `i_attr_element` (`attribute_id`,`element_id`),
) ENGINE=InnoDB AUTO_INCREMENT=4777429 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_attribute_values`
--

LOCK TABLES `ca_attribute_values` WRITE;
/*!40000 ALTER TABLE `ca_attribute_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_attribute_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_attributes`
--

DROP TABLE IF EXISTS `ca_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_attributes` (
  `attribute_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `element_id` smallint(5) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`attribute_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_row_id` (`row_id`),
  KEY `i_table_num` (`table_num`),
  KEY `i_element_id` (`element_id`),
  KEY `i_row_table_num` (`row_id`,`table_num`),
  KEY `i_prefetch` (`row_id`,`element_id`,`table_num`),
) ENGINE=InnoDB AUTO_INCREMENT=3619033 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_attributes`
--

LOCK TABLES `ca_attributes` WRITE;
/*!40000 ALTER TABLE `ca_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_batch_log`
--

DROP TABLE IF EXISTS `ca_batch_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_batch_log` (
  `batch_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `log_datetime` int(10) unsigned NOT NULL,
  `notes` text NOT NULL,
  `batch_type` char(2) NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `elapsed_time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`batch_id`),
  KEY `i_log_datetime` (`log_datetime`),
  KEY `i_user_id` (`user_id`),
  CONSTRAINT `fk_ca_batch_log_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=15518 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_batch_log`
--

LOCK TABLES `ca_batch_log` WRITE;
/*!40000 ALTER TABLE `ca_batch_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_batch_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_batch_log_items`
--

DROP TABLE IF EXISTS `ca_batch_log_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_batch_log_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `batch_id` int(10) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `errors` longtext,
  PRIMARY KEY (`item_id`),
  KEY `i_row_id` (`row_id`),
  KEY `i_batch_row_id` (`batch_id`,`row_id`),
) ENGINE=InnoDB AUTO_INCREMENT=2396415 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_batch_log_items`
--

LOCK TABLES `ca_batch_log_items` WRITE;
/*!40000 ALTER TABLE `ca_batch_log_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_batch_log_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bookmark_folders`
--

DROP TABLE IF EXISTS `ca_bookmark_folders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bookmark_folders` (
  `folder_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`folder_id`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bookmark_folders`
--

LOCK TABLES `ca_bookmark_folders` WRITE;
/*!40000 ALTER TABLE `ca_bookmark_folders` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_bookmark_folders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bookmarks`
--

DROP TABLE IF EXISTS `ca_bookmarks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bookmarks` (
  `bookmark_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `folder_id` int(10) unsigned NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `notes` text NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `created_on` int(10) unsigned NOT NULL,
  PRIMARY KEY (`bookmark_id`),
  KEY `i_row_id` (`row_id`),
  KEY `i_folder_id` (`folder_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bookmarks`
--

LOCK TABLES `ca_bookmarks` WRITE;
/*!40000 ALTER TABLE `ca_bookmarks` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_bookmarks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bundle_display_labels`
--

DROP TABLE IF EXISTS `ca_bundle_display_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bundle_display_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `display_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_display_id` (`display_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bundle_display_labels`
--

LOCK TABLES `ca_bundle_display_labels` WRITE;
/*!40000 ALTER TABLE `ca_bundle_display_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_bundle_display_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bundle_display_placements`
--

DROP TABLE IF EXISTS `ca_bundle_display_placements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bundle_display_placements` (
  `placement_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `display_id` int(10) unsigned NOT NULL,
  `bundle_name` varchar(255) NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  PRIMARY KEY (`placement_id`),
  KEY `i_bundle_name` (`bundle_name`),
  KEY `i_rank` (`rank`),
  KEY `i_display_id` (`display_id`)
) ENGINE=InnoDB AUTO_INCREMENT=177 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bundle_display_placements`
--

LOCK TABLES `ca_bundle_display_placements` WRITE;
/*!40000 ALTER TABLE `ca_bundle_display_placements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_bundle_display_placements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bundle_display_type_restrictions`
--

DROP TABLE IF EXISTS `ca_bundle_display_type_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bundle_display_type_restrictions` (
  `restriction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `display_id` int(10) unsigned NOT NULL,
  `include_subtypes` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`restriction_id`),
  KEY `i_display_id` (`display_id`),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bundle_display_type_restrictions`
--

LOCK TABLES `ca_bundle_display_type_restrictions` WRITE;
/*!40000 ALTER TABLE `ca_bundle_display_type_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_bundle_display_type_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bundle_displays`
--

DROP TABLE IF EXISTS `ca_bundle_displays`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bundle_displays` (
  `display_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `display_code` varchar(100) DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `is_system` tinyint(3) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `settings` text NOT NULL,
  PRIMARY KEY (`display_id`),
  UNIQUE KEY `u_display_code` (`display_code`),
  KEY `i_user_id` (`user_id`),
  KEY `i_table_num` (`table_num`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bundle_displays`
--

LOCK TABLES `ca_bundle_displays` WRITE;
/*!40000 ALTER TABLE `ca_bundle_displays` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_bundle_displays` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bundle_displays_x_user_groups`
--

DROP TABLE IF EXISTS `ca_bundle_displays_x_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bundle_displays_x_user_groups` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `display_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_display_id` (`display_id`),
  KEY `i_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bundle_displays_x_user_groups`
--

LOCK TABLES `ca_bundle_displays_x_user_groups` WRITE;
/*!40000 ALTER TABLE `ca_bundle_displays_x_user_groups` DISABLE KEYS */;
INSERT INTO `ca_bundle_displays_x_user_groups` VALUES (1,6,4,1),(2,6,3,1),(3,6,2,2);
/*!40000 ALTER TABLE `ca_bundle_displays_x_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_bundle_displays_x_users`
--

DROP TABLE IF EXISTS `ca_bundle_displays_x_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_bundle_displays_x_users` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `display_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_display_id` (`display_id`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_bundle_displays_x_users`
--

LOCK TABLES `ca_bundle_displays_x_users` WRITE;
/*!40000 ALTER TABLE `ca_bundle_displays_x_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_bundle_displays_x_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_change_log`
--

DROP TABLE IF EXISTS `ca_change_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_change_log` (
  `log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `log_datetime` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `changetype` char(1) NOT NULL,
  `logged_table_num` tinyint(3) unsigned NOT NULL,
  `logged_row_id` int(10) unsigned NOT NULL,
  `rolledback` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `unit_id` char(32) DEFAULT NULL,
  `batch_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `i_datetime` (`log_datetime`),
  KEY `i_user_id` (`user_id`),
  KEY `i_logged` (`logged_row_id`,`logged_table_num`),
  KEY `i_unit_id` (`unit_id`),
  KEY `i_table_num` (`logged_table_num`),
  KEY `i_batch_id` (`batch_id`),
  KEY `i_date_unit` (`log_datetime`,`unit_id`)
) ENGINE=InnoDB AUTO_INCREMENT=20775769 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_change_log`
--

LOCK TABLES `ca_change_log` WRITE;
/*!40000 ALTER TABLE `ca_change_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_change_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_change_log_snapshots`
--

DROP TABLE IF EXISTS `ca_change_log_snapshots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_change_log_snapshots` (
  `log_id` bigint(20) NOT NULL,
  `snapshot` longblob NOT NULL,
  KEY `i_log_id` (`log_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_change_log_snapshots`
--

LOCK TABLES `ca_change_log_snapshots` WRITE;
/*!40000 ALTER TABLE `ca_change_log_snapshots` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_change_log_snapshots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_change_log_subjects`
--

DROP TABLE IF EXISTS `ca_change_log_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_change_log_subjects` (
  `log_id` bigint(20) NOT NULL,
  `subject_table_num` tinyint(3) unsigned NOT NULL,
  `subject_row_id` int(10) unsigned NOT NULL,
  KEY `i_log_id` (`log_id`),
  KEY `i_subject` (`subject_row_id`,`subject_table_num`),
  KEY `i_log_plus` (`log_id`,`subject_table_num`,`subject_row_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_change_log_subjects`
--

LOCK TABLES `ca_change_log_subjects` WRITE;
/*!40000 ALTER TABLE `ca_change_log_subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_change_log_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_collection_labels`
--

DROP TABLE IF EXISTS `ca_collection_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_collection_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `collection_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`collection_id`,`name`,`type_id`,`locale_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_name_sort` (`name_sort`(128)),
) ENGINE=InnoDB AUTO_INCREMENT=2225 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_collection_labels`
--

LOCK TABLES `ca_collection_labels` WRITE;
/*!40000 ALTER TABLE `ca_collection_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_collection_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_collections`
--

DROP TABLE IF EXISTS `ca_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_collections` (
  `collection_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `hier_collection_id` int(10) unsigned NOT NULL,
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `acl_inherit_from_parent` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`collection_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_idno` (`idno`),
  KEY `i_idno_sort` (`idno_sort`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_hier_collection_id` (`hier_collection_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_acl_inherit_from_parent` (`acl_inherit_from_parent`),
  KEY `i_view_count` (`view_count`),
  KEY `i_collection_filter` (`collection_id`,`deleted`,`access`),
) ENGINE=InnoDB AUTO_INCREMENT=1034 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_collections`
--

LOCK TABLES `ca_collections` WRITE;
/*!40000 ALTER TABLE `ca_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_collections_x_collections`
--

DROP TABLE IF EXISTS `ca_collections_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_collections_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `collection_left_id` int(10) unsigned NOT NULL,
  `collection_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`collection_left_id`,`collection_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_collection_left_id` (`collection_left_id`),
  KEY `i_collection_right_id` (`collection_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_collections_x_collections`
--

LOCK TABLES `ca_collections_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_collections_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_collections_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_collections_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_collections_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_collections_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`collection_id`,`location_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_collections_x_storage_locations`
--

LOCK TABLES `ca_collections_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_collections_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_collections_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_collections_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_collections_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_collections_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`collection_id`,`type_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_collections_x_vocabulary_terms`
--

LOCK TABLES `ca_collections_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_collections_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_collections_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_exporter_items`
--

DROP TABLE IF EXISTS `ca_data_exporter_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_exporter_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `exporter_id` int(10) unsigned NOT NULL,
  `element` varchar(1024) NOT NULL,
  `context` varchar(1024) DEFAULT NULL,
  `source` varchar(1024) DEFAULT NULL,
  `settings` longtext NOT NULL,
  `hier_item_id` int(10) unsigned NOT NULL,
  `hier_left` decimal(30,20) unsigned NOT NULL,
  `hier_right` decimal(30,20) unsigned NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_exporter_id` (`exporter_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_hier_item_id` (`hier_item_id`),
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_exporter_items`
--

LOCK TABLES `ca_data_exporter_items` WRITE;
/*!40000 ALTER TABLE `ca_data_exporter_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_exporter_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_exporter_labels`
--

DROP TABLE IF EXISTS `ca_data_exporter_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_exporter_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exporter_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`exporter_id`,`locale_id`,`name`,`is_preferred`),
  KEY `i_exporter_id` (`exporter_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_name_sort` (`name_sort`(128)),
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_exporter_labels`
--

LOCK TABLES `ca_data_exporter_labels` WRITE;
/*!40000 ALTER TABLE `ca_data_exporter_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_exporter_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_exporters`
--

DROP TABLE IF EXISTS `ca_data_exporters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_exporters` (
  `exporter_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exporter_code` varchar(100) NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `settings` longtext NOT NULL,
  PRIMARY KEY (`exporter_id`),
  UNIQUE KEY `u_exporter_code` (`exporter_code`),
  KEY `i_table_num` (`table_num`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_exporters`
--

LOCK TABLES `ca_data_exporters` WRITE;
/*!40000 ALTER TABLE `ca_data_exporters` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_exporters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_import_event_log`
--

DROP TABLE IF EXISTS `ca_data_import_event_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_import_event_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned DEFAULT NULL,
  `type_code` char(10) NOT NULL,
  `date_time` int(10) unsigned NOT NULL,
  `message` text NOT NULL,
  `source` varchar(255) NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `i_event_id` (`event_id`),
  KEY `i_item_id` (`item_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_import_event_log`
--

LOCK TABLES `ca_data_import_event_log` WRITE;
/*!40000 ALTER TABLE `ca_data_import_event_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_import_event_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_import_events`
--

DROP TABLE IF EXISTS `ca_data_import_events`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_import_events` (
  `event_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurred_on` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `description` text NOT NULL,
  `type_code` char(50) NOT NULL,
  `source` text NOT NULL,
  PRIMARY KEY (`event_id`),
  KEY `i_user_id` (`user_id`),
) ENGINE=InnoDB AUTO_INCREMENT=2143 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_import_events`
--

LOCK TABLES `ca_data_import_events` WRITE;
/*!40000 ALTER TABLE `ca_data_import_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_import_events` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_import_items`
--

DROP TABLE IF EXISTS `ca_data_import_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_import_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `event_id` int(10) unsigned NOT NULL,
  `source_ref` varchar(255) NOT NULL,
  `table_num` tinyint(3) unsigned DEFAULT NULL,
  `row_id` int(10) unsigned DEFAULT NULL,
  `type_code` char(1) DEFAULT NULL,
  `started_on` int(10) unsigned NOT NULL,
  `completed_on` int(10) unsigned DEFAULT NULL,
  `elapsed_time` decimal(8,4) DEFAULT NULL,
  `success` tinyint(3) unsigned DEFAULT NULL,
  `message` text NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `i_event_id` (`event_id`),
  KEY `i_row_id` (`table_num`,`row_id`),
) ENGINE=InnoDB AUTO_INCREMENT=376177 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_import_items`
--

LOCK TABLES `ca_data_import_items` WRITE;
/*!40000 ALTER TABLE `ca_data_import_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_import_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_importer_groups`
--

DROP TABLE IF EXISTS `ca_data_importer_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_importer_groups` (
  `group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `importer_id` int(10) unsigned NOT NULL,
  `group_code` varchar(100) NOT NULL,
  `destination` varchar(1024) NOT NULL,
  `settings` longtext NOT NULL,
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `u_group_code` (`importer_id`,`group_code`),
  KEY `i_importer_id` (`importer_id`),
) ENGINE=InnoDB AUTO_INCREMENT=371 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_importer_groups`
--

LOCK TABLES `ca_data_importer_groups` WRITE;
/*!40000 ALTER TABLE `ca_data_importer_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_importer_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_importer_items`
--

DROP TABLE IF EXISTS `ca_data_importer_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_importer_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `importer_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `source` varchar(1024) NOT NULL,
  `destination` varchar(1024) NOT NULL,
  `settings` longtext NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `i_importer_id` (`importer_id`),
  KEY `i_group_id` (`group_id`),
) ENGINE=InnoDB AUTO_INCREMENT=403 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_importer_items`
--

LOCK TABLES `ca_data_importer_items` WRITE;
/*!40000 ALTER TABLE `ca_data_importer_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_importer_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_importer_labels`
--

DROP TABLE IF EXISTS `ca_data_importer_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_importer_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `importer_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`importer_id`,`locale_id`,`name`,`is_preferred`),
  KEY `i_importer_id` (`importer_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_name_sort` (`name_sort`(128)),
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_importer_labels`
--

LOCK TABLES `ca_data_importer_labels` WRITE;
/*!40000 ALTER TABLE `ca_data_importer_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_importer_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_importer_log`
--

DROP TABLE IF EXISTS `ca_data_importer_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_importer_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `importer_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `log_datetime` int(10) unsigned NOT NULL,
  `notes` text NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `datafile` longblob NOT NULL,
  PRIMARY KEY (`log_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_importer_id` (`importer_id`),
  KEY `i_log_datetime` (`log_datetime`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_importer_log`
--

LOCK TABLES `ca_data_importer_log` WRITE;
/*!40000 ALTER TABLE `ca_data_importer_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_importer_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_importer_log_items`
--

DROP TABLE IF EXISTS `ca_data_importer_log_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_importer_log_items` (
  `log_item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_id` int(10) unsigned NOT NULL,
  `log_datetime` int(10) unsigned NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `type_code` char(10) NOT NULL,
  `notes` text NOT NULL,
  PRIMARY KEY (`log_item_id`),
  KEY `i_log_id` (`log_id`),
  KEY `i_row_id` (`row_id`),
  KEY `i_log_datetime` (`log_datetime`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_importer_log_items`
--

LOCK TABLES `ca_data_importer_log_items` WRITE;
/*!40000 ALTER TABLE `ca_data_importer_log_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_importer_log_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_data_importers`
--

DROP TABLE IF EXISTS `ca_data_importers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_data_importers` (
  `importer_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `importer_code` varchar(100) NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `settings` longtext NOT NULL,
  `rules` longtext NOT NULL,
  `worksheet` longblob NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`importer_id`),
  UNIQUE KEY `u_importer_code` (`importer_code`),
  KEY `i_table_num` (`table_num`)
) ENGINE=InnoDB AUTO_INCREMENT=71 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_data_importers`
--

LOCK TABLES `ca_data_importers` WRITE;
/*!40000 ALTER TABLE `ca_data_importers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_data_importers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_download_log`
--

DROP TABLE IF EXISTS `ca_download_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_download_log` (
  `log_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_datetime` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `ip_addr` varchar(39) DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `representation_id` int(10) unsigned DEFAULT NULL,
  `download_source` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `fk_ca_download_log_user_id` (`user_id`),
  KEY `fk_ca_download_log_representation_id` (`representation_id`),
  KEY `i_table_num_row_id` (`table_num`,`row_id`),
  KEY `i_log_datetime` (`log_datetime`),
  CONSTRAINT `fk_ca_download_log_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3131 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_download_log`
--

LOCK TABLES `ca_download_log` WRITE;
/*!40000 ALTER TABLE `ca_download_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_download_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_bundle_placements`
--

DROP TABLE IF EXISTS `ca_editor_ui_bundle_placements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_bundle_placements` (
  `placement_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screen_id` int(10) unsigned NOT NULL,
  `placement_code` varchar(255) NOT NULL,
  `bundle_name` varchar(255) NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  PRIMARY KEY (`placement_id`),
  UNIQUE KEY `u_bundle_name` (`bundle_name`,`screen_id`,`placement_code`),
  KEY `i_screen_id` (`screen_id`)
) ENGINE=InnoDB AUTO_INCREMENT=415 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_bundle_placements`
--

LOCK TABLES `ca_editor_ui_bundle_placements` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_bundle_placements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_ui_bundle_placements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_labels`
--

DROP TABLE IF EXISTS `ca_editor_ui_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ui_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `locale_id` smallint(6) NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_ui_id` (`ui_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_labels`
--

LOCK TABLES `ca_editor_ui_labels` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_ui_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_screen_labels`
--

DROP TABLE IF EXISTS `ca_editor_ui_screen_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_screen_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screen_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `locale_id` smallint(6) NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_screen_id` (`screen_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_screen_labels`
--

LOCK TABLES `ca_editor_ui_screen_labels` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_screen_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_ui_screen_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_screen_type_restrictions`
--

DROP TABLE IF EXISTS `ca_editor_ui_screen_type_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_screen_type_restrictions` (
  `restriction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `screen_id` int(10) unsigned NOT NULL,
  `include_subtypes` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`restriction_id`),
  KEY `i_screen_id` (`screen_id`),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_screen_type_restrictions`
--

LOCK TABLES `ca_editor_ui_screen_type_restrictions` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_screen_type_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_ui_screen_type_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_screens`
--

DROP TABLE IF EXISTS `ca_editor_ui_screens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_screens` (
  `screen_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `ui_id` int(10) unsigned NOT NULL,
  `idno` varchar(255) NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint(3) unsigned NOT NULL,
  `color` char(6) DEFAULT NULL,
  `icon` longblob NOT NULL,
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  PRIMARY KEY (`screen_id`),
  KEY `i_ui_id` (`ui_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_screens`
--

LOCK TABLES `ca_editor_ui_screens` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_screens` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_ui_screens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_screens_x_roles`
--

DROP TABLE IF EXISTS `ca_editor_ui_screens_x_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_screens_x_roles` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screen_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_screen_id` (`screen_id`),
  KEY `i_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_screens_x_roles`
--

LOCK TABLES `ca_editor_ui_screens_x_roles` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_screens_x_roles` DISABLE KEYS */;
INSERT INTO `ca_editor_ui_screens_x_roles` VALUES (1,92,1,2),(2,92,2,2);
/*!40000 ALTER TABLE `ca_editor_ui_screens_x_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_screens_x_user_groups`
--

DROP TABLE IF EXISTS `ca_editor_ui_screens_x_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_screens_x_user_groups` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screen_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_screen_id` (`screen_id`),
  KEY `i_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_screens_x_user_groups`
--

LOCK TABLES `ca_editor_ui_screens_x_user_groups` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_screens_x_user_groups` DISABLE KEYS */;
INSERT INTO `ca_editor_ui_screens_x_user_groups` VALUES (1,98,8,2),(2,98,10,2);
/*!40000 ALTER TABLE `ca_editor_ui_screens_x_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_screens_x_users`
--

DROP TABLE IF EXISTS `ca_editor_ui_screens_x_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_screens_x_users` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `screen_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_screen_id` (`screen_id`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_screens_x_users`
--

LOCK TABLES `ca_editor_ui_screens_x_users` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_screens_x_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_ui_screens_x_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_ui_type_restrictions`
--

DROP TABLE IF EXISTS `ca_editor_ui_type_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_ui_type_restrictions` (
  `restriction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `ui_id` int(10) unsigned NOT NULL,
  `include_subtypes` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`restriction_id`),
  KEY `i_ui_id` (`ui_id`),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_ui_type_restrictions`
--

LOCK TABLES `ca_editor_ui_type_restrictions` WRITE;
/*!40000 ALTER TABLE `ca_editor_ui_type_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_ui_type_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_uis`
--

DROP TABLE IF EXISTS `ca_editor_uis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_uis` (
  `ui_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `is_system_ui` tinyint(3) unsigned NOT NULL,
  `editor_type` tinyint(3) unsigned NOT NULL,
  `editor_code` varchar(100) DEFAULT NULL,
  `color` char(6) DEFAULT NULL,
  `icon` longblob NOT NULL,
  PRIMARY KEY (`ui_id`),
  UNIQUE KEY `u_code` (`editor_code`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_uis`
--

LOCK TABLES `ca_editor_uis` WRITE;
/*!40000 ALTER TABLE `ca_editor_uis` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_uis` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_uis_x_roles`
--

DROP TABLE IF EXISTS `ca_editor_uis_x_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_uis_x_roles` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ui_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_ui_id` (`ui_id`),
  KEY `i_role_id` (`role_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_uis_x_roles`
--

LOCK TABLES `ca_editor_uis_x_roles` WRITE;
/*!40000 ALTER TABLE `ca_editor_uis_x_roles` DISABLE KEYS */;
INSERT INTO `ca_editor_uis_x_roles` VALUES (1,14,1,2);
/*!40000 ALTER TABLE `ca_editor_uis_x_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_uis_x_user_groups`
--

DROP TABLE IF EXISTS `ca_editor_uis_x_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_uis_x_user_groups` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ui_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_ui_id` (`ui_id`),
  KEY `i_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_uis_x_user_groups`
--

LOCK TABLES `ca_editor_uis_x_user_groups` WRITE;
/*!40000 ALTER TABLE `ca_editor_uis_x_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_editor_uis_x_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_editor_uis_x_users`
--

DROP TABLE IF EXISTS `ca_editor_uis_x_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_editor_uis_x_users` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `ui_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_ui_id` (`ui_id`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_editor_uis_x_users`
--

LOCK TABLES `ca_editor_uis_x_users` WRITE;
/*!40000 ALTER TABLE `ca_editor_uis_x_users` DISABLE KEYS */;
INSERT INTO `ca_editor_uis_x_users` VALUES (1,24,65,2),(2,25,65,2),(3,14,65,2);
/*!40000 ALTER TABLE `ca_editor_uis_x_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entities`
--

DROP TABLE IF EXISTS `ca_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entities` (
  `entity_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `source_id` int(10) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `source_info` longtext NOT NULL,
  `life_sdatetime` decimal(30,20) DEFAULT NULL,
  `life_edatetime` decimal(30,20) DEFAULT NULL,
  `hier_entity_id` int(10) unsigned NOT NULL,
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entity_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_idno` (`idno`),
  KEY `i_idno_sort` (`idno_sort`),
  KEY `i_hier_entity_id` (`hier_entity_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_life_sdatetime` (`life_sdatetime`),
  KEY `i_life_edatetime` (`life_edatetime`),
  KEY `i_view_count` (`view_count`),
  KEY `i_entity_filter` (`entity_id`,`deleted`,`access`),
  CONSTRAINT `fk_ca_entities_type_id` FOREIGN KEY (`type_id`) REFERENCES `ca_list_items` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12683 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entities`
--

LOCK TABLES `ca_entities` WRITE;
/*!40000 ALTER TABLE `ca_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entities_x_collections`
--

DROP TABLE IF EXISTS `ca_entities_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entities_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`collection_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=72 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entities_x_collections`
--

LOCK TABLES `ca_entities_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_entities_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entities_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entities_x_entities`
--

DROP TABLE IF EXISTS `ca_entities_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entities_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_left_id` int(10) unsigned NOT NULL,
  `entity_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_left_id`,`entity_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_left_id` (`entity_left_id`),
  KEY `i_entity_right_id` (`entity_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entities_x_entities`
--

LOCK TABLES `ca_entities_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_entities_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entities_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entities_x_occurrences`
--

DROP TABLE IF EXISTS `ca_entities_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entities_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`type_id`,`entity_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entities_x_occurrences`
--

LOCK TABLES `ca_entities_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_entities_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entities_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entities_x_places`
--

DROP TABLE IF EXISTS `ca_entities_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entities_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`place_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_place_id` (`place_id`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=136 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entities_x_places`
--

LOCK TABLES `ca_entities_x_places` WRITE;
/*!40000 ALTER TABLE `ca_entities_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entities_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entities_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_entities_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entities_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`location_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entities_x_storage_locations`
--

LOCK TABLES `ca_entities_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_entities_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entities_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entities_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_entities_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entities_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`type_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_object_id` (`entity_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entities_x_vocabulary_terms`
--

LOCK TABLES `ca_entities_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_entities_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entities_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_entity_labels`
--

DROP TABLE IF EXISTS `ca_entity_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_entity_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `displayname` varchar(512) NOT NULL,
  `forename` varchar(100) NOT NULL,
  `other_forenames` varchar(100) NOT NULL,
  `middlename` varchar(100) NOT NULL,
  `surname` varchar(512) NOT NULL,
  `prefix` varchar(100) NOT NULL,
  `suffix` varchar(100) NOT NULL,
  `name_sort` varchar(512) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_forename` (`forename`),
  KEY `i_surname` (`surname`(128)),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_name_sort` (`name_sort`(128)),
) ENGINE=InnoDB AUTO_INCREMENT=17182 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_entity_labels`
--

LOCK TABLES `ca_entity_labels` WRITE;
/*!40000 ALTER TABLE `ca_entity_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_entity_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_eventlog`
--

DROP TABLE IF EXISTS `ca_eventlog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_eventlog` (
  `date_time` int(10) unsigned NOT NULL,
  `code` char(4) NOT NULL,
  `message` text NOT NULL,
  `source` varchar(255) NOT NULL,
  KEY `i_when` (`date_time`),
  KEY `i_source` (`source`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_eventlog`
--

LOCK TABLES `ca_eventlog` WRITE;
/*!40000 ALTER TABLE `ca_eventlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_eventlog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_groups_x_roles`
--

DROP TABLE IF EXISTS `ca_groups_x_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_groups_x_roles` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_id` int(10) unsigned NOT NULL,
  `role_id` smallint(5) unsigned NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_group_id` (`group_id`),
  KEY `i_role_id` (`role_id`),
  KEY `u_all` (`group_id`,`role_id`),
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_groups_x_roles`
--

LOCK TABLES `ca_groups_x_roles` WRITE;
/*!40000 ALTER TABLE `ca_groups_x_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_groups_x_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_guids`
--

DROP TABLE IF EXISTS `ca_guids`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_guids` (
  `guid_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `guid` varchar(36) NOT NULL,
  PRIMARY KEY (`guid_id`),
  UNIQUE KEY `u_guid` (`guid`),
  KEY `i_table_num_row_id` (`table_num`,`row_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12042875 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_guids`
--

LOCK TABLES `ca_guids` WRITE;
/*!40000 ALTER TABLE `ca_guids` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_guids` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_history_tracking_current_values`
--

DROP TABLE IF EXISTS `ca_history_tracking_current_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_history_tracking_current_values` (
  `tracking_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `policy` varchar(50) NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `current_table_num` tinyint(3) unsigned DEFAULT NULL,
  `current_type_id` int(10) unsigned DEFAULT NULL,
  `current_row_id` int(10) unsigned DEFAULT NULL,
  `tracked_table_num` tinyint(3) unsigned DEFAULT NULL,
  `tracked_type_id` int(10) unsigned DEFAULT NULL,
  `tracked_row_id` int(10) unsigned DEFAULT NULL,
  `is_future` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`tracking_id`),
  UNIQUE KEY `u_all` (`row_id`,`table_num`,`policy`,`type_id`),
  KEY `i_policy` (`policy`),
  KEY `i_row_id` (`row_id`),
  KEY `i_current` (`current_row_id`,`current_table_num`,`current_type_id`),
  KEY `i_tracked` (`tracked_row_id`,`tracked_table_num`,`tracked_type_id`),
  KEY `i_is_future` (`is_future`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_history_tracking_current_values`
--

LOCK TABLES `ca_history_tracking_current_values` WRITE;
/*!40000 ALTER TABLE `ca_history_tracking_current_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_history_tracking_current_values` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_ips`
--

DROP TABLE IF EXISTS `ca_ips`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_ips` (
  `ip_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `ip1` tinyint(3) unsigned NOT NULL,
  `ip2` tinyint(3) unsigned DEFAULT NULL,
  `ip3` tinyint(3) unsigned DEFAULT NULL,
  `ip4s` tinyint(3) unsigned DEFAULT NULL,
  `ip4e` tinyint(3) unsigned DEFAULT NULL,
  `notes` text NOT NULL,
  PRIMARY KEY (`ip_id`),
  UNIQUE KEY `u_ip` (`ip1`,`ip2`,`ip3`,`ip4s`,`ip4e`),
  KEY `i_user_id` (`user_id`),
  CONSTRAINT `fk_ca_ips_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_ips`
--

LOCK TABLES `ca_ips` WRITE;
/*!40000 ALTER TABLE `ca_ips` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_ips` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_item_comments`
--

DROP TABLE IF EXISTS `ca_item_comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_item_comments` (
  `comment_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `media1` longblob NOT NULL,
  `media2` longblob NOT NULL,
  `media3` longblob NOT NULL,
  `media4` longblob NOT NULL,
  `comment` text,
  `rating` tinyint(4) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `created_on` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ip_addr` varchar(39) DEFAULT NULL,
  `moderated_on` int(10) unsigned DEFAULT NULL,
  `moderated_by_user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `i_row_id` (`row_id`),
  KEY `i_table_num` (`table_num`),
  KEY `i_email` (`email`),
  KEY `i_user_id` (`user_id`),
  KEY `i_created_on` (`created_on`),
  KEY `i_access` (`access`),
  KEY `i_moderated_on` (`moderated_on`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_item_comments`
--

LOCK TABLES `ca_item_comments` WRITE;
/*!40000 ALTER TABLE `ca_item_comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_item_comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_item_tags`
--

DROP TABLE IF EXISTS `ca_item_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_item_tags` (
  `tag_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locale_id` smallint(5) unsigned NOT NULL,
  `tag` varchar(255) NOT NULL,
  PRIMARY KEY (`tag_id`),
  KEY `u_tag` (`tag`,`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_item_tags`
--

LOCK TABLES `ca_item_tags` WRITE;
/*!40000 ALTER TABLE `ca_item_tags` DISABLE KEYS */;
INSERT INTO `ca_item_tags` VALUES (1,1,'child'),(2,1,'father');
/*!40000 ALTER TABLE `ca_item_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_items_x_tags`
--

DROP TABLE IF EXISTS `ca_items_x_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_items_x_tags` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `tag_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `ip_addr` varchar(39) DEFAULT NULL,
  `created_on` int(10) unsigned NOT NULL,
  `moderated_on` int(10) unsigned DEFAULT NULL,
  `moderated_by_user_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_row_id` (`row_id`),
  KEY `i_table_num` (`table_num`),
  KEY `i_tag_id` (`tag_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_access` (`access`),
  KEY `i_created_on` (`created_on`),
  KEY `i_moderated_on` (`moderated_on`),
  KEY `i_rank` (`rank`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_items_x_tags`
--

LOCK TABLES `ca_items_x_tags` WRITE;
/*!40000 ALTER TABLE `ca_items_x_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_items_x_tags` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_list_item_labels`
--

DROP TABLE IF EXISTS `ca_list_item_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_list_item_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name_singular` varchar(255) NOT NULL,
  `name_plural` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`item_id`,`name_singular`,`name_plural`,`type_id`,`locale_id`),
  KEY `fk_ca_list_item_labels_locale_id` (`locale_id`),
  KEY `i_name_singular` (`item_id`,`name_singular`(128)),
  KEY `i_name` (`item_id`,`name_plural`(128)),
  KEY `i_item_id` (`item_id`),
  KEY `i_name_sort` (`name_sort`(128)),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB AUTO_INCREMENT=642 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_list_item_labels`
--

LOCK TABLES `ca_list_item_labels` WRITE;
/*!40000 ALTER TABLE `ca_list_item_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_list_item_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_list_items`
--

DROP TABLE IF EXISTS `ca_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_list_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `list_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `item_value` varchar(255) NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `is_enabled` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `validation_format` varchar(255) NOT NULL,
  `settings` longtext NOT NULL,
  `color` char(6) DEFAULT NULL,
  `icon` longblob NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  PRIMARY KEY (`item_id`),
  KEY `i_list_id` (`list_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_idno` (`idno`),
  KEY `i_idno_sort` (`idno_sort`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_value_text` (`item_value`),
  KEY `i_type_id` (`type_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_item_filter` (`item_id`,`deleted`,`access`),
  CONSTRAINT `fk_ca_list_items_list_id` FOREIGN KEY (`list_id`) REFERENCES `ca_lists` (`list_id`),
) ENGINE=InnoDB AUTO_INCREMENT=361 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_list_items`
--

LOCK TABLES `ca_list_items` WRITE;
/*!40000 ALTER TABLE `ca_list_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_list_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_list_items_x_list_items`
--

DROP TABLE IF EXISTS `ca_list_items_x_list_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_list_items_x_list_items` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `term_left_id` int(10) unsigned NOT NULL,
  `term_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`term_left_id`,`term_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_term_left_id` (`term_left_id`),
  KEY `i_term_right_id` (`term_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_list_items_x_list_items`
--

LOCK TABLES `ca_list_items_x_list_items` WRITE;
/*!40000 ALTER TABLE `ca_list_items_x_list_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_list_items_x_list_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_list_labels`
--

DROP TABLE IF EXISTS `ca_list_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_list_labels` (
  `label_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `list_id` smallint(5) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_locale_id` (`list_id`,`locale_id`),
  KEY `fk_ca_list_labels_locale_id` (`locale_id`),
  KEY `i_list_id` (`list_id`),
  KEY `i_name` (`name`(128)),
  CONSTRAINT `fk_ca_list_labels_list_id` FOREIGN KEY (`list_id`) REFERENCES `ca_lists` (`list_id`),
) ENGINE=InnoDB AUTO_INCREMENT=138 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_list_labels`
--

LOCK TABLES `ca_list_labels` WRITE;
/*!40000 ALTER TABLE `ca_list_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_list_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_lists`
--

DROP TABLE IF EXISTS `ca_lists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_lists` (
  `list_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `list_code` varchar(100) NOT NULL,
  `is_system_list` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_hierarchical` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `use_as_vocabulary` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `default_sort` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`list_id`),
  UNIQUE KEY `u_code` (`list_code`)
) ENGINE=InnoDB AUTO_INCREMENT=60 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_lists`
--

LOCK TABLES `ca_lists` WRITE;
/*!40000 ALTER TABLE `ca_lists` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_lists` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loan_labels`
--

DROP TABLE IF EXISTS `ca_loan_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loan_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(1024) NOT NULL,
  `name_sort` varchar(1024) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_locale_id_id` (`locale_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_name_sort` (`name_sort`(128)),
  CONSTRAINT `fk_ca_loan_labels_loan_id` FOREIGN KEY (`loan_id`) REFERENCES `ca_loans` (`loan_id`),
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loan_labels`
--

LOCK TABLES `ca_loan_labels` WRITE;
/*!40000 ALTER TABLE `ca_loan_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loan_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans`
--

DROP TABLE IF EXISTS `ca_loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans` (
  `loan_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `hier_loan_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`loan_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `idno` (`idno`),
  KEY `idno_sort` (`idno_sort`),
  KEY `hier_left` (`hier_left`),
  KEY `hier_right` (`hier_right`),
  KEY `hier_loan_id` (`hier_loan_id`),
  KEY `i_view_count` (`view_count`),
  KEY `i_loan_filter` (`loan_id`,`deleted`,`access`),
  CONSTRAINT `fk_ca_loans_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `ca_loans` (`loan_id`),
  CONSTRAINT `fk_ca_loans_type_id` FOREIGN KEY (`type_id`) REFERENCES `ca_list_items` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans`
--

LOCK TABLES `ca_loans` WRITE;
/*!40000 ALTER TABLE `ca_loans` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_collections`
--

DROP TABLE IF EXISTS `ca_loans_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`collection_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_collections`
--

LOCK TABLES `ca_loans_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_entities`
--

DROP TABLE IF EXISTS `ca_loans_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`entity_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_entities`
--

LOCK TABLES `ca_loans_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_loans`
--

DROP TABLE IF EXISTS `ca_loans_x_loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_loans` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_left_id` int(10) unsigned NOT NULL,
  `loan_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` text NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_left_id`,`loan_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_left_id` (`loan_left_id`),
  KEY `i_loan_right_id` (`loan_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_loans`
--

LOCK TABLES `ca_loans_x_loans` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_loans` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_movements`
--

DROP TABLE IF EXISTS `ca_loans_x_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_movements` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `movement_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`movement_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_movements`
--

LOCK TABLES `ca_loans_x_movements` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_movements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_object_lots`
--

DROP TABLE IF EXISTS `ca_loans_x_object_lots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_object_lots` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `lot_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`lot_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_object_lots`
--

LOCK TABLES `ca_loans_x_object_lots` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_object_lots` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_object_lots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_object_representations`
--

DROP TABLE IF EXISTS `ca_loans_x_object_representations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_object_representations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `loan_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`loan_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_object_representations`
--

LOCK TABLES `ca_loans_x_object_representations` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_object_representations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_object_representations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_objects`
--

DROP TABLE IF EXISTS `ca_loans_x_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_objects` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`object_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_objects`
--

LOCK TABLES `ca_loans_x_objects` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_occurrences`
--

DROP TABLE IF EXISTS `ca_loans_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `occurrence_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`occurrence_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_occurrences`
--

LOCK TABLES `ca_loans_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_places`
--

DROP TABLE IF EXISTS `ca_loans_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`place_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_place_id` (`place_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_places`
--

LOCK TABLES `ca_loans_x_places` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_loans_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`location_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_storage_locations`
--

LOCK TABLES `ca_loans_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_loans_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_loans_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_loans_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `loan_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`loan_id`,`item_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_loan_id` (`loan_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_loans_x_vocabulary_terms`
--

LOCK TABLES `ca_loans_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_loans_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_loans_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_locales`
--

DROP TABLE IF EXISTS `ca_locales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_locales` (
  `locale_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `language` varchar(3) NOT NULL,
  `country` char(2) NOT NULL,
  `dialect` varchar(8) DEFAULT NULL,
  `dont_use_for_cataloguing` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`locale_id`),
  KEY `u_language_country` (`language`,`country`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_locales`
--

LOCK TABLES `ca_locales` WRITE;
/*!40000 ALTER TABLE `ca_locales` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_locales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_media_content_locations`
--

DROP TABLE IF EXISTS `ca_media_content_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_media_content_locations` (
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `content` text NOT NULL,
  `loc` longtext NOT NULL,
  KEY `i_row_id` (`row_id`,`table_num`),
  KEY `i_content` (`content`(255))
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_media_content_locations`
--

LOCK TABLES `ca_media_content_locations` WRITE;
/*!40000 ALTER TABLE `ca_media_content_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_media_content_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_media_replication_status_check`
--

DROP TABLE IF EXISTS `ca_media_replication_status_check`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_media_replication_status_check` (
  `check_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `target` varchar(255) NOT NULL,
  `created_on` int(10) unsigned NOT NULL,
  `last_check` int(10) unsigned NOT NULL,
  PRIMARY KEY (`check_id`),
  KEY `i_row_id` (`row_id`,`table_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_media_replication_status_check`
--

LOCK TABLES `ca_media_replication_status_check` WRITE;
/*!40000 ALTER TABLE `ca_media_replication_status_check` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_media_replication_status_check` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_alert_rule_labels`
--

DROP TABLE IF EXISTS `ca_metadata_alert_rule_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_alert_rule_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_rule_id` (`rule_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_alert_rule_labels`
--

LOCK TABLES `ca_metadata_alert_rule_labels` WRITE;
/*!40000 ALTER TABLE `ca_metadata_alert_rule_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_alert_rule_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_alert_rule_type_restrictions`
--

DROP TABLE IF EXISTS `ca_metadata_alert_rule_type_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_alert_rule_type_restrictions` (
  `restriction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `rule_id` int(10) unsigned NOT NULL,
  `include_subtypes` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`restriction_id`),
  KEY `i_rule_id` (`rule_id`),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_alert_rule_type_restrictions`
--

LOCK TABLES `ca_metadata_alert_rule_type_restrictions` WRITE;
/*!40000 ALTER TABLE `ca_metadata_alert_rule_type_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_alert_rule_type_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_alert_rules`
--

DROP TABLE IF EXISTS `ca_metadata_alert_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_alert_rules` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `code` varchar(20) NOT NULL,
  `settings` longtext NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`rule_id`),
  KEY `i_table_num` (`table_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_alert_rules`
--

LOCK TABLES `ca_metadata_alert_rules` WRITE;
/*!40000 ALTER TABLE `ca_metadata_alert_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_alert_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_alert_rules_x_user_groups`
--

DROP TABLE IF EXISTS `ca_metadata_alert_rules_x_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_alert_rules_x_user_groups` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_rule_id` (`rule_id`),
  KEY `i_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_alert_rules_x_user_groups`
--

LOCK TABLES `ca_metadata_alert_rules_x_user_groups` WRITE;
/*!40000 ALTER TABLE `ca_metadata_alert_rules_x_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_alert_rules_x_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_alert_rules_x_users`
--

DROP TABLE IF EXISTS `ca_metadata_alert_rules_x_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_alert_rules_x_users` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_rule_id` (`rule_id`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_alert_rules_x_users`
--

LOCK TABLES `ca_metadata_alert_rules_x_users` WRITE;
/*!40000 ALTER TABLE `ca_metadata_alert_rules_x_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_alert_rules_x_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_alert_triggers`
--

DROP TABLE IF EXISTS `ca_metadata_alert_triggers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_alert_triggers` (
  `trigger_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned NOT NULL,
  `element_id` smallint(5) unsigned DEFAULT NULL,
  `settings` longtext NOT NULL,
  `trigger_type` varchar(30) NOT NULL,
  `element_filters` text NOT NULL,
  PRIMARY KEY (`trigger_id`),
  KEY `fk_alert_rules_rule_id` (`rule_id`),
  KEY `fk_ca_metadata_alert_triggers_element_id` (`element_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_alert_triggers`
--

LOCK TABLES `ca_metadata_alert_triggers` WRITE;
/*!40000 ALTER TABLE `ca_metadata_alert_triggers` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_alert_triggers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_dictionary_entries`
--

DROP TABLE IF EXISTS `ca_metadata_dictionary_entries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_dictionary_entries` (
  `entry_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `bundle_name` varchar(255) NOT NULL,
  `settings` longtext NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry_id`),
  KEY `i_table_num` (`table_num`),
  KEY `i_name` (`bundle_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_dictionary_entries`
--

LOCK TABLES `ca_metadata_dictionary_entries` WRITE;
/*!40000 ALTER TABLE `ca_metadata_dictionary_entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_dictionary_entries` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_dictionary_entry_labels`
--

DROP TABLE IF EXISTS `ca_metadata_dictionary_entry_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_dictionary_entry_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entry_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_entry_id` (`entry_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_dictionary_entry_labels`
--

LOCK TABLES `ca_metadata_dictionary_entry_labels` WRITE;
/*!40000 ALTER TABLE `ca_metadata_dictionary_entry_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_dictionary_entry_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_dictionary_rule_violations`
--

DROP TABLE IF EXISTS `ca_metadata_dictionary_rule_violations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_dictionary_rule_violations` (
  `violation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `rule_id` int(10) unsigned NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `created_on` int(10) unsigned NOT NULL,
  `last_checked_on` int(10) unsigned NOT NULL,
  PRIMARY KEY (`violation_id`),
  KEY `i_rule_id` (`rule_id`),
  KEY `i_row_id` (`row_id`,`table_num`),
  KEY `i_created_on` (`created_on`),
  KEY `i_last_checked_on` (`last_checked_on`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_dictionary_rule_violations`
--

LOCK TABLES `ca_metadata_dictionary_rule_violations` WRITE;
/*!40000 ALTER TABLE `ca_metadata_dictionary_rule_violations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_dictionary_rule_violations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_dictionary_rules`
--

DROP TABLE IF EXISTS `ca_metadata_dictionary_rules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_dictionary_rules` (
  `rule_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entry_id` int(10) unsigned NOT NULL,
  `rule_code` varchar(100) NOT NULL,
  `expression` text NOT NULL,
  `rule_level` char(4) NOT NULL,
  `settings` longtext NOT NULL,
  PRIMARY KEY (`rule_id`),
  UNIQUE KEY `u_rule_code` (`entry_id`,`rule_code`),
  KEY `i_entry_id` (`entry_id`),
  KEY `i_rule_code` (`rule_level`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_dictionary_rules`
--

LOCK TABLES `ca_metadata_dictionary_rules` WRITE;
/*!40000 ALTER TABLE `ca_metadata_dictionary_rules` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_dictionary_rules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_element_labels`
--

DROP TABLE IF EXISTS `ca_metadata_element_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_element_labels` (
  `label_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `element_id` smallint(5) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_element_id` (`element_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_locale_id` (`locale_id`),
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_element_labels`
--

LOCK TABLES `ca_metadata_element_labels` WRITE;
/*!40000 ALTER TABLE `ca_metadata_element_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_element_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_elements`
--

DROP TABLE IF EXISTS `ca_metadata_elements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_elements` (
  `element_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` smallint(5) unsigned DEFAULT NULL,
  `list_id` smallint(5) unsigned DEFAULT NULL,
  `element_code` varchar(30) NOT NULL,
  `documentation_url` varchar(255) NOT NULL,
  `datatype` tinyint(3) unsigned NOT NULL,
  `settings` longtext NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `hier_element_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`element_id`),
  UNIQUE KEY `u_name_short` (`element_code`),
  KEY `i_hier_element_id` (`hier_element_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_list_id` (`list_id`),
) ENGINE=InnoDB AUTO_INCREMENT=105 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_elements`
--

LOCK TABLES `ca_metadata_elements` WRITE;
/*!40000 ALTER TABLE `ca_metadata_elements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_elements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_metadata_type_restrictions`
--

DROP TABLE IF EXISTS `ca_metadata_type_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_metadata_type_restrictions` (
  `restriction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `element_id` smallint(5) unsigned NOT NULL,
  `settings` longtext NOT NULL,
  `include_subtypes` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`restriction_id`),
  KEY `i_table_num` (`table_num`),
  KEY `i_type_id` (`type_id`),
  KEY `i_element_id` (`element_id`),
  KEY `i_include_subtypes` (`include_subtypes`),
) ENGINE=InnoDB AUTO_INCREMENT=113 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_metadata_type_restrictions`
--

LOCK TABLES `ca_metadata_type_restrictions` WRITE;
/*!40000 ALTER TABLE `ca_metadata_type_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_metadata_type_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movement_labels`
--

DROP TABLE IF EXISTS `ca_movement_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movement_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(1024) NOT NULL,
  `name_sort` varchar(1024) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_locale_id_id` (`locale_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_name_sort` (`name_sort`(128)),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movement_labels`
--

LOCK TABLES `ca_movement_labels` WRITE;
/*!40000 ALTER TABLE `ca_movement_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movement_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements`
--

DROP TABLE IF EXISTS `ca_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements` (
  `movement_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`movement_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `idno` (`idno`),
  KEY `idno_sort` (`idno_sort`),
  KEY `i_view_count` (`view_count`),
  KEY `i_movement_filter` (`movement_id`,`deleted`,`access`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements`
--

LOCK TABLES `ca_movements` WRITE;
/*!40000 ALTER TABLE `ca_movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_collections`
--

DROP TABLE IF EXISTS `ca_movements_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`collection_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_collections`
--

LOCK TABLES `ca_movements_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_entities`
--

DROP TABLE IF EXISTS `ca_movements_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`entity_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_entities`
--

LOCK TABLES `ca_movements_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_movements`
--

DROP TABLE IF EXISTS `ca_movements_x_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_movements` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_left_id` int(10) unsigned NOT NULL,
  `movement_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` text NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_left_id`,`movement_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_left_id` (`movement_left_id`),
  KEY `i_movement_right_id` (`movement_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_movements`
--

LOCK TABLES `ca_movements_x_movements` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_movements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_object_lots`
--

DROP TABLE IF EXISTS `ca_movements_x_object_lots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_object_lots` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `lot_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`lot_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_object_lots`
--

LOCK TABLES `ca_movements_x_object_lots` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_object_lots` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_object_lots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_object_representations`
--

DROP TABLE IF EXISTS `ca_movements_x_object_representations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_object_representations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `movement_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`movement_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_object_representations`
--

LOCK TABLES `ca_movements_x_object_representations` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_object_representations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_object_representations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_objects`
--

DROP TABLE IF EXISTS `ca_movements_x_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_objects` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`object_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_objects`
--

LOCK TABLES `ca_movements_x_objects` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_occurrences`
--

DROP TABLE IF EXISTS `ca_movements_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `occurrence_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`occurrence_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_occurrences`
--

LOCK TABLES `ca_movements_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_places`
--

DROP TABLE IF EXISTS `ca_movements_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`place_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_place_id` (`place_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_places`
--

LOCK TABLES `ca_movements_x_places` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_movements_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`location_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_storage_locations`
--

LOCK TABLES `ca_movements_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_movements_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_movements_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_movements_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `movement_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`movement_id`,`item_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_movement_id` (`movement_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_movements_x_vocabulary_terms`
--

LOCK TABLES `ca_movements_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_movements_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_movements_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_multipart_idno_sequences`
--

DROP TABLE IF EXISTS `ca_multipart_idno_sequences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_multipart_idno_sequences` (
  `idno_stub` varchar(255) NOT NULL,
  `format` varchar(100) NOT NULL,
  `element` varchar(100) NOT NULL,
  `seq` int(10) unsigned NOT NULL,
  PRIMARY KEY (`idno_stub`,`format`,`element`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_multipart_idno_sequences`
--

LOCK TABLES `ca_multipart_idno_sequences` WRITE;
/*!40000 ALTER TABLE `ca_multipart_idno_sequences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_multipart_idno_sequences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_notification_subjects`
--

DROP TABLE IF EXISTS `ca_notification_subjects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_notification_subjects` (
  `subject_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `notification_id` int(10) unsigned NOT NULL,
  `was_read` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `read_on` int(10) unsigned DEFAULT NULL,
  `delivery_email` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `delivery_email_sent_on` int(10) unsigned DEFAULT NULL,
  `delivery_inbox` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`subject_id`),
  KEY `i_notification_id` (`notification_id`),
  KEY `i_table_num_row_id` (`table_num`,`row_id`,`read_on`),
  KEY `i_delivery_email` (`delivery_email`,`delivery_email_sent_on`),
  KEY `i_delivery_inbox` (`delivery_inbox`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_notification_subjects`
--

LOCK TABLES `ca_notification_subjects` WRITE;
/*!40000 ALTER TABLE `ca_notification_subjects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_notification_subjects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_notifications`
--

DROP TABLE IF EXISTS `ca_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_notifications` (
  `notification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `notification_type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `datetime` int(10) unsigned NOT NULL,
  `message` longtext,
  `is_system` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `notification_key` char(32) NOT NULL DEFAULT '',
  `extra_data` longtext NOT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `i_datetime` (`datetime`),
  KEY `i_notification_type` (`notification_type`),
  KEY `i_notification_key` (`notification_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_notifications`
--

LOCK TABLES `ca_notifications` WRITE;
/*!40000 ALTER TABLE `ca_notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_checkouts`
--

DROP TABLE IF EXISTS `ca_object_checkouts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_checkouts` (
  `checkout_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group_uuid` char(36) NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `created_on` int(10) unsigned NOT NULL,
  `checkout_date` int(10) unsigned DEFAULT NULL,
  `due_date` int(10) unsigned DEFAULT NULL,
  `return_date` int(10) unsigned DEFAULT NULL,
  `checkout_notes` text NOT NULL,
  `return_notes` text NOT NULL,
  `last_sent_coming_due_email` int(10) unsigned DEFAULT NULL,
  `last_sent_overdue_email` int(10) unsigned DEFAULT NULL,
  `last_reservation_available_email` int(10) unsigned DEFAULT NULL,
  `deleted` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`checkout_id`),
  KEY `i_group_uuid` (`group_uuid`),
  KEY `i_object_id` (`object_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_created_on` (`created_on`),
  KEY `i_checkout_date` (`checkout_date`),
  KEY `i_due_date` (`due_date`),
  KEY `i_return_date` (`return_date`),
  KEY `i_last_sent_coming_due_email` (`last_sent_coming_due_email`),
  KEY `i_last_reservation_available_email` (`last_reservation_available_email`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_checkouts`
--

LOCK TABLES `ca_object_checkouts` WRITE;
/*!40000 ALTER TABLE `ca_object_checkouts` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_checkouts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_labels`
--

DROP TABLE IF EXISTS `ca_object_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(1024) NOT NULL,
  `name_sort` varchar(1024) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`object_id`,`name`(255),`type_id`,`locale_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_object_id` (`object_id`),
  KEY `i_name_sort` (`name_sort`(128)),
  KEY `i_type_id` (`type_id`),
  KEY `i_locale_id` (`locale_id`),
) ENGINE=InnoDB AUTO_INCREMENT=774574 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_labels`
--

LOCK TABLES `ca_object_labels` WRITE;
/*!40000 ALTER TABLE `ca_object_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lot_labels`
--

DROP TABLE IF EXISTS `ca_object_lot_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lot_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lot_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(1024) NOT NULL,
  `name_sort` varchar(1024) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`lot_id`,`name`(255),`type_id`,`locale_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_name_sort` (`name_sort`(128)),
  KEY `i_type_id` (`type_id`),
  KEY `i_locale_id` (`locale_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lot_labels`
--

LOCK TABLES `ca_object_lot_labels` WRITE;
/*!40000 ALTER TABLE `ca_object_lot_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lot_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots`
--

DROP TABLE IF EXISTS `ca_object_lots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots` (
  `lot_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` int(10) unsigned NOT NULL,
  `lot_status_id` int(10) unsigned NOT NULL,
  `idno_stub` varchar(255) NOT NULL,
  `idno_stub_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `extent` smallint(5) unsigned NOT NULL,
  `extent_units` varchar(255) NOT NULL,
  `access` tinyint(4) NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`lot_id`),
  KEY `i_admin_idno_stub` (`idno_stub`),
  KEY `i_type_id` (`type_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_admin_idno_stub_sort` (`idno_stub_sort`),
  KEY `i_lot_status_id` (`lot_status_id`),
  KEY `i_view_count` (`view_count`),
  KEY `i_lot_filter` (`lot_id`,`deleted`,`access`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots`
--

LOCK TABLES `ca_object_lots` WRITE;
/*!40000 ALTER TABLE `ca_object_lots` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_collections`
--

DROP TABLE IF EXISTS `ca_object_lots_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lot_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`lot_id`,`collection_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_collections`
--

LOCK TABLES `ca_object_lots_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_entities`
--

DROP TABLE IF EXISTS `ca_object_lots_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `lot_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_entities`
--

LOCK TABLES `ca_object_lots_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_object_lots`
--

DROP TABLE IF EXISTS `ca_object_lots_x_object_lots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_object_lots` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lot_left_id` int(10) unsigned NOT NULL,
  `lot_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`lot_left_id`,`lot_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_lot_left_id` (`lot_left_id`),
  KEY `i_lot_right_id` (`lot_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_object_lots`
--

LOCK TABLES `ca_object_lots_x_object_lots` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_object_lots` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_object_lots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_object_representations`
--

DROP TABLE IF EXISTS `ca_object_lots_x_object_representations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_object_representations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `lot_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`lot_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_object_representations`
--

LOCK TABLES `ca_object_lots_x_object_representations` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_object_representations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_object_representations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_occurrences`
--

DROP TABLE IF EXISTS `ca_object_lots_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `lot_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`lot_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_occurrences`
--

LOCK TABLES `ca_object_lots_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_places`
--

DROP TABLE IF EXISTS `ca_object_lots_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `lot_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_place_id` (`place_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_places`
--

LOCK TABLES `ca_object_lots_x_places` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_object_lots_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lot_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`lot_id`,`type_id`,`sdatetime`,`edatetime`,`location_id`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_storage_locations`
--

LOCK TABLES `ca_object_lots_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_lots_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_object_lots_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_lots_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `lot_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`lot_id`,`type_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_lots_x_vocabulary_terms`
--

LOCK TABLES `ca_object_lots_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_object_lots_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_lots_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representation_captions`
--

DROP TABLE IF EXISTS `ca_object_representation_captions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representation_captions` (
  `caption_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `caption_file` longblob NOT NULL,
  `caption_content` longtext NOT NULL,
  PRIMARY KEY (`caption_id`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_locale_id` (`locale_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representation_captions`
--

LOCK TABLES `ca_object_representation_captions` WRITE;
/*!40000 ALTER TABLE `ca_object_representation_captions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representation_captions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representation_labels`
--

DROP TABLE IF EXISTS `ca_object_representation_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representation_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(1024) NOT NULL,
  `name_sort` varchar(1024) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `fk_ca_object_representation_labels_type_id` (`type_id`),
  KEY `fk_ca_object_representation_labels_locale_id` (`locale_id`),
  KEY `fk_ca_object_representation_labels_representation_id` (`representation_id`),
) ENGINE=InnoDB AUTO_INCREMENT=440615 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representation_labels`
--

LOCK TABLES `ca_object_representation_labels` WRITE;
/*!40000 ALTER TABLE `ca_object_representation_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representation_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representation_multifiles`
--

DROP TABLE IF EXISTS `ca_object_representation_multifiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representation_multifiles` (
  `multifile_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `resource_path` text NOT NULL,
  `media` longblob NOT NULL,
  `media_metadata` longblob NOT NULL,
  `media_content` longtext NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`multifile_id`),
  KEY `i_resource_path` (`resource_path`(255)),
  KEY `i_representation_id` (`representation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=42641 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representation_multifiles`
--

LOCK TABLES `ca_object_representation_multifiles` WRITE;
/*!40000 ALTER TABLE `ca_object_representation_multifiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representation_multifiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations`
--

DROP TABLE IF EXISTS `ca_object_representations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations` (
  `representation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `md5` varchar(32) NOT NULL,
  `mimetype` varchar(255) DEFAULT NULL,
  `original_filename` varchar(1024) NOT NULL,
  `media` longblob NOT NULL,
  `media_metadata` longblob,
  `media_content` longtext,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  PRIMARY KEY (`representation_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_idno` (`idno`),
  KEY `i_idno_sort` (`idno_sort`),
  KEY `i_md5` (`md5`),
  KEY `i_mimetype` (`mimetype`),
  KEY `i_original_filename` (`original_filename`(128)),
  KEY `i_rank` (`rank`),
  KEY `i_source_id` (`source_id`),
  KEY `i_view_count` (`view_count`),
  KEY `i_rep_filter` (`representation_id`,`deleted`,`access`),
) ENGINE=InnoDB AUTO_INCREMENT=440941 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations`
--

LOCK TABLES `ca_object_representations` WRITE;
/*!40000 ALTER TABLE `ca_object_representations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations_x_collections`
--

DROP TABLE IF EXISTS `ca_object_representations_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`collection_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=103 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations_x_collections`
--

LOCK TABLES `ca_object_representations_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_object_representations_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations_x_entities`
--

DROP TABLE IF EXISTS `ca_object_representations_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`entity_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations_x_entities`
--

LOCK TABLES `ca_object_representations_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_object_representations_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations_x_object_representations`
--

DROP TABLE IF EXISTS `ca_object_representations_x_object_representations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations_x_object_representations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_left_id` int(10) unsigned NOT NULL,
  `representation_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` text NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_representation_left_id` (`representation_left_id`),
  KEY `i_representation_right_id` (`representation_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations_x_object_representations`
--

LOCK TABLES `ca_object_representations_x_object_representations` WRITE;
/*!40000 ALTER TABLE `ca_object_representations_x_object_representations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations_x_object_representations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations_x_occurrences`
--

DROP TABLE IF EXISTS `ca_object_representations_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `occurrence_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`occurrence_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations_x_occurrences`
--

LOCK TABLES `ca_object_representations_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_object_representations_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations_x_places`
--

DROP TABLE IF EXISTS `ca_object_representations_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`place_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_place_id` (`place_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations_x_places`
--

LOCK TABLES `ca_object_representations_x_places` WRITE;
/*!40000 ALTER TABLE `ca_object_representations_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_object_representations_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`representation_id`,`location_id`,`sdatetime`,`edatetime`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations_x_storage_locations`
--

LOCK TABLES `ca_object_representations_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_object_representations_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_object_representations_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_object_representations_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_object_representations_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_primary` tinyint(4) NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`representation_id`,`type_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_object_representations_x_vocabulary_terms`
--

LOCK TABLES `ca_object_representations_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_object_representations_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_object_representations_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects`
--

DROP TABLE IF EXISTS `ca_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects` (
  `object_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `lot_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `source_id` int(10) unsigned DEFAULT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `type_id` int(10) unsigned NOT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `acquisition_type_id` int(10) unsigned DEFAULT NULL,
  `item_status_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `hier_object_id` int(10) unsigned NOT NULL,
  `hier_left` decimal(30,20) unsigned NOT NULL,
  `hier_right` decimal(30,20) unsigned NOT NULL,
  `extent` int(10) unsigned NOT NULL,
  `extent_units` varchar(255) NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `acl_inherit_from_ca_collections` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `acl_inherit_from_parent` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `access_inherit_from_parent` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `home_location_id` int(10) unsigned DEFAULT NULL,
  `accession_sdatetime` decimal(30,20) DEFAULT NULL,
  `accession_edatetime` decimal(30,20) DEFAULT NULL,
  `deaccession_sdatetime` decimal(30,20) DEFAULT NULL,
  `deaccession_edatetime` decimal(30,20) DEFAULT NULL,
  `is_deaccessioned` tinyint(4) NOT NULL DEFAULT '0',
  `deaccession_notes` text NOT NULL,
  `deaccession_type_id` int(10) unsigned DEFAULT NULL,
  `current_loc_class` tinyint(3) unsigned DEFAULT NULL,
  `current_loc_subclass` int(10) unsigned DEFAULT NULL,
  `current_loc_id` int(10) unsigned DEFAULT NULL,
  `circulation_status_id` int(10) unsigned DEFAULT NULL,
  `deaccession_disposal_sdatetime` decimal(30,20) DEFAULT NULL,
  `deaccession_disposal_edatetime` decimal(30,20) DEFAULT NULL,
  PRIMARY KEY (`object_id`),
  KEY `fk_ca_objects_acquisition_type_id` (`acquisition_type_id`),
  KEY `fk_ca_objects_circulation_status_id` (`circulation_status_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_idno` (`idno`),
  KEY `i_idno_sort` (`idno_sort`),
  KEY `i_type_id` (`type_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_lot_id` (`lot_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_hier_object_id` (`hier_object_id`),
  KEY `i_acqusition_type_id` (`source_id`,`acquisition_type_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_item_status_id` (`item_status_id`),
  KEY `i_acl_inherit_from_parent` (`acl_inherit_from_parent`),
  KEY `i_acl_inherit_from_ca_collections` (`acl_inherit_from_ca_collections`),
  KEY `i_home_location_id` (`home_location_id`),
  KEY `i_accession_sdatetime` (`accession_sdatetime`),
  KEY `i_accession_edatetime` (`accession_edatetime`),
  KEY `i_deaccession_sdatetime` (`deaccession_sdatetime`),
  KEY `i_deaccession_edatetime` (`deaccession_edatetime`),
  KEY `i_deaccession_type_id` (`deaccession_type_id`),
  KEY `i_is_deaccessioned` (`is_deaccessioned`),
  KEY `i_current_loc_class` (`current_loc_class`),
  KEY `i_current_loc_subclass` (`current_loc_subclass`),
  KEY `i_current_loc_id` (`current_loc_id`),
  KEY `i_view_count` (`view_count`),
  KEY `i_obj_filter` (`object_id`,`deleted`,`access`),
  KEY `i_deaccession_disposal_sdatetime` (`deaccession_disposal_sdatetime`),
  KEY `i_deaccession_disposal_edatetime` (`deaccession_disposal_edatetime`),
  CONSTRAINT `fk_ca_objects_lot_id` FOREIGN KEY (`lot_id`) REFERENCES `ca_object_lots` (`lot_id`),
  CONSTRAINT `fk_ca_objects_type_id` FOREIGN KEY (`type_id`) REFERENCES `ca_list_items` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=299852 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects`
--

LOCK TABLES `ca_objects` WRITE;
/*!40000 ALTER TABLE `ca_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_collections`
--

DROP TABLE IF EXISTS `ca_objects_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_id`,`collection_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_object_id` (`object_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=461151 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_collections`
--

LOCK TABLES `ca_objects_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_entities`
--

DROP TABLE IF EXISTS `ca_objects_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`object_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=590097 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_entities`
--

LOCK TABLES `ca_objects_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_object_representations`
--

DROP TABLE IF EXISTS `ca_objects_x_object_representations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_object_representations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `representation_id` int(10) unsigned NOT NULL,
  `is_primary` tinyint(4) NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_id`,`representation_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_representation_id` (`representation_id`),
) ENGINE=InnoDB AUTO_INCREMENT=436325 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_object_representations`
--

LOCK TABLES `ca_objects_x_object_representations` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_object_representations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects_x_object_representations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_objects`
--

DROP TABLE IF EXISTS `ca_objects_x_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_objects` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_left_id` int(10) unsigned NOT NULL,
  `object_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` text NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_left_id`,`object_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_object_left_id` (`object_left_id`),
  KEY `i_object_right_id` (`object_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=3327 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_objects`
--

LOCK TABLES `ca_objects_x_objects` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects_x_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_occurrences`
--

DROP TABLE IF EXISTS `ca_objects_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`object_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=12755 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_occurrences`
--

LOCK TABLES `ca_objects_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_places`
--

DROP TABLE IF EXISTS `ca_objects_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`object_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_place_id` (`place_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=127959 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_places`
--

LOCK TABLES `ca_objects_x_places` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_objects_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_id`,`type_id`,`sdatetime`,`edatetime`,`location_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=719 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_storage_locations`
--

LOCK TABLES `ca_objects_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_objects_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_objects_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_objects_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_objects_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_id`,`type_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_object_id` (`object_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_objects_x_vocabulary_terms`
--

LOCK TABLES `ca_objects_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_objects_x_vocabulary_terms` DISABLE KEYS */;
INSERT INTO `ca_objects_x_vocabulary_terms` VALUES (1,1426,123,232,'',NULL,NULL,NULL,NULL,1);
/*!40000 ALTER TABLE `ca_objects_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_occurrence_labels`
--

DROP TABLE IF EXISTS `ca_occurrence_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_occurrence_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(1024) NOT NULL,
  `name_sort` varchar(1024) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`name`(255),`type_id`,`locale_id`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_name_sort` (`name_sort`(255)),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB AUTO_INCREMENT=442 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_occurrence_labels`
--

LOCK TABLES `ca_occurrence_labels` WRITE;
/*!40000 ALTER TABLE `ca_occurrence_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_occurrence_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_occurrences`
--

DROP TABLE IF EXISTS `ca_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_occurrences` (
  `occurrence_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `hier_occurrence_id` int(10) unsigned NOT NULL,
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`occurrence_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_hier_occurrence_id` (`hier_occurrence_id`),
  KEY `i_view_count` (`view_count`),
  KEY `i_occ_filter` (`occurrence_id`,`deleted`,`access`),
) ENGINE=InnoDB AUTO_INCREMENT=379 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_occurrences`
--

LOCK TABLES `ca_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_occurrences_x_collections`
--

DROP TABLE IF EXISTS `ca_occurrences_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_occurrences_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`collection_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_occurrences_x_collections`
--

LOCK TABLES `ca_occurrences_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_occurrences_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_occurrences_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_occurrences_x_occurrences`
--

DROP TABLE IF EXISTS `ca_occurrences_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_occurrences_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_left_id` int(10) unsigned NOT NULL,
  `occurrence_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_left_id`,`occurrence_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_left_id` (`occurrence_left_id`),
  KEY `i_occurrence_right_id` (`occurrence_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_occurrences_x_occurrences`
--

LOCK TABLES `ca_occurrences_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_occurrences_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_occurrences_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_occurrences_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_occurrences_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_occurrences_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`location_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_occurrences_x_storage_locations`
--

LOCK TABLES `ca_occurrences_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_occurrences_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_occurrences_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_occurrences_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_occurrences_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_occurrences_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`type_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_object_id` (`occurrence_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_occurrences_x_vocabulary_terms`
--

LOCK TABLES `ca_occurrences_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_occurrences_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_occurrences_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_persistent_cache`
--

DROP TABLE IF EXISTS `ca_persistent_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_persistent_cache` (
  `cache_key` char(32) NOT NULL,
  `cache_value` longblob NOT NULL,
  `created_on` int(10) unsigned NOT NULL,
  `updated_on` int(10) unsigned NOT NULL,
  `namespace` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`cache_key`),
  KEY `i_namespace` (`namespace`),
  KEY `i_updated_on` (`updated_on`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_persistent_cache`
--

LOCK TABLES `ca_persistent_cache` WRITE;
/*!40000 ALTER TABLE `ca_persistent_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_persistent_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_place_labels`
--

DROP TABLE IF EXISTS `ca_place_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_place_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`place_id`,`name`,`type_id`,`locale_id`),
  KEY `i_place_id` (`place_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_name_sort` (`name_sort`(128)),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB AUTO_INCREMENT=1720 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_place_labels`
--

LOCK TABLES `ca_place_labels` WRITE;
/*!40000 ALTER TABLE `ca_place_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_place_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_places`
--

DROP TABLE IF EXISTS `ca_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_places` (
  `place_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `source_id` int(10) unsigned DEFAULT NULL,
  `hierarchy_id` int(10) unsigned NOT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `source_info` longtext NOT NULL,
  `lifespan_sdate` decimal(30,20) DEFAULT NULL,
  `lifespan_edate` decimal(30,20) DEFAULT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `floorplan` longblob NOT NULL,
  PRIMARY KEY (`place_id`),
  KEY `i_hierarchy_id` (`hierarchy_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_idno` (`idno`),
  KEY `i_idno_sort` (`idno_sort`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_source_id` (`source_id`),
  KEY `i_life_sdatetime` (`lifespan_sdate`),
  KEY `i_life_edatetime` (`lifespan_edate`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_view_count` (`view_count`),
  KEY `i_place_filter` (`place_id`,`deleted`,`access`),
  CONSTRAINT `fk_ca_places_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `ca_places` (`place_id`),
  CONSTRAINT `fk_ca_places_type_id` FOREIGN KEY (`type_id`) REFERENCES `ca_list_items` (`item_id`)
) ENGINE=InnoDB AUTO_INCREMENT=956 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_places`
--

LOCK TABLES `ca_places` WRITE;
/*!40000 ALTER TABLE `ca_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_places_x_collections`
--

DROP TABLE IF EXISTS `ca_places_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_places_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `collection_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`collection_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_place_id` (`place_id`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=92 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_places_x_collections`
--

LOCK TABLES `ca_places_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_places_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_places_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_places_x_occurrences`
--

DROP TABLE IF EXISTS `ca_places_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_places_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`occurrence_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_place_id` (`place_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_places_x_occurrences`
--

LOCK TABLES `ca_places_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_places_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_places_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_places_x_places`
--

DROP TABLE IF EXISTS `ca_places_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_places_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_left_id` int(10) unsigned NOT NULL,
  `place_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_left_id`,`place_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_place_left_id` (`place_left_id`),
  KEY `i_place_right_id` (`place_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_places_x_places`
--

LOCK TABLES `ca_places_x_places` WRITE;
/*!40000 ALTER TABLE `ca_places_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_places_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_places_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_places_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_places_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `location_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`location_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_place_id` (`place_id`),
  KEY `i_location_id` (`location_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_places_x_storage_locations`
--

LOCK TABLES `ca_places_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_places_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_places_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_places_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_places_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_places_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`type_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_place_id` (`place_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_places_x_vocabulary_terms`
--

LOCK TABLES `ca_places_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_places_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_places_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_relationship_relationships`
--

DROP TABLE IF EXISTS `ca_relationship_relationships`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_relationship_relationships` (
  `reification_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` smallint(5) unsigned NOT NULL,
  `relationship_table_num` tinyint(3) unsigned NOT NULL,
  `relation_id` int(10) unsigned NOT NULL,
  `table_num` tinyint(4) NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  PRIMARY KEY (`reification_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_relation_row` (`relation_id`,`relationship_table_num`),
  KEY `i_target_row` (`row_id`,`table_num`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_relationship_relationships`
--

LOCK TABLES `ca_relationship_relationships` WRITE;
/*!40000 ALTER TABLE `ca_relationship_relationships` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_relationship_relationships` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_relationship_type_labels`
--

DROP TABLE IF EXISTS `ca_relationship_type_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_relationship_type_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type_id` smallint(5) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `typename` varchar(255) NOT NULL,
  `typename_reverse` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `description_reverse` text NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_typename` (`type_id`,`locale_id`,`typename`),
  UNIQUE KEY `u_typename_reverse` (`typename_reverse`,`type_id`,`locale_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_locale_id` (`locale_id`),
) ENGINE=InnoDB AUTO_INCREMENT=247 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_relationship_type_labels`
--

LOCK TABLES `ca_relationship_type_labels` WRITE;
/*!40000 ALTER TABLE `ca_relationship_type_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_relationship_type_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_relationship_types`
--

DROP TABLE IF EXISTS `ca_relationship_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_relationship_types` (
  `type_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` smallint(5) unsigned DEFAULT NULL,
  `sub_type_left_id` int(10) unsigned DEFAULT NULL,
  `include_subtypes_left` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `sub_type_right_id` int(10) unsigned DEFAULT NULL,
  `include_subtypes_right` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `hier_left` decimal(30,20) unsigned NOT NULL,
  `hier_right` decimal(30,20) unsigned NOT NULL,
  `hier_type_id` smallint(5) unsigned DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `type_code` varchar(30) NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `is_default` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE KEY `u_type_code` (`type_code`,`table_num`),
  KEY `i_table_num` (`table_num`),
  KEY `i_sub_type_left_id` (`sub_type_left_id`),
  KEY `i_sub_type_right_id` (`sub_type_right_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_hier_type_id` (`hier_type_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
) ENGINE=InnoDB AUTO_INCREMENT=182 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_relationship_types`
--

LOCK TABLES `ca_relationship_types` WRITE;
/*!40000 ALTER TABLE `ca_relationship_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_relationship_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_replication_log`
--

DROP TABLE IF EXISTS `ca_replication_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_replication_log` (
  `entry_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `source_system_guid` varchar(36) NOT NULL,
  `log_id` int(10) unsigned NOT NULL,
  `status` char(1) NOT NULL,
  `vars` longtext,
  PRIMARY KEY (`entry_id`),
  KEY `i_source_log` (`source_system_guid`,`log_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_replication_log`
--

LOCK TABLES `ca_replication_log` WRITE;
/*!40000 ALTER TABLE `ca_replication_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_replication_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_representation_annotation_labels`
--

DROP TABLE IF EXISTS `ca_representation_annotation_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_representation_annotation_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` text NOT NULL,
  `name_sort` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`name`(128),`locale_id`,`type_id`,`annotation_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_name_sort` (`name_sort`(128)),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_representation_annotation_labels`
--

LOCK TABLES `ca_representation_annotation_labels` WRITE;
/*!40000 ALTER TABLE `ca_representation_annotation_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_representation_annotation_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_representation_annotations`
--

DROP TABLE IF EXISTS `ca_representation_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_representation_annotations` (
  `annotation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `type_code` varchar(30) NOT NULL,
  `props` longtext NOT NULL,
  `preview` longblob NOT NULL,
  `source_info` longtext NOT NULL,
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`annotation_id`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_view_count` (`view_count`),
  CONSTRAINT `fk_ca_rep_annot_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_representation_annotations`
--

LOCK TABLES `ca_representation_annotations` WRITE;
/*!40000 ALTER TABLE `ca_representation_annotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_representation_annotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_representation_annotations_x_entities`
--

DROP TABLE IF EXISTS `ca_representation_annotations_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_representation_annotations_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_representation_annotations_x_entities`
--

LOCK TABLES `ca_representation_annotations_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_representation_annotations_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_representation_annotations_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_representation_annotations_x_objects`
--

DROP TABLE IF EXISTS `ca_representation_annotations_x_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_representation_annotations_x_objects` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_object_id` (`object_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_representation_annotations_x_objects`
--

LOCK TABLES `ca_representation_annotations_x_objects` WRITE;
/*!40000 ALTER TABLE `ca_representation_annotations_x_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_representation_annotations_x_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_representation_annotations_x_occurrences`
--

DROP TABLE IF EXISTS `ca_representation_annotations_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_representation_annotations_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `occurrence_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_representation_annotations_x_occurrences`
--

LOCK TABLES `ca_representation_annotations_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_representation_annotations_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_representation_annotations_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_representation_annotations_x_places`
--

DROP TABLE IF EXISTS `ca_representation_annotations_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_representation_annotations_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_place_id` (`place_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_representation_annotations_x_places`
--

LOCK TABLES `ca_representation_annotations_x_places` WRITE;
/*!40000 ALTER TABLE `ca_representation_annotations_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_representation_annotations_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_representation_annotations_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_representation_annotations_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_representation_annotations_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`annotation_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_representation_annotations_x_vocabulary_terms`
--

LOCK TABLES `ca_representation_annotations_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_representation_annotations_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_representation_annotations_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_schema_updates`
--

DROP TABLE IF EXISTS `ca_schema_updates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_schema_updates` (
  `version_num` int(10) unsigned NOT NULL,
  `datetime` int(10) unsigned NOT NULL,
  UNIQUE KEY `u_version_num` (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_schema_updates`
--

LOCK TABLES `ca_schema_updates` WRITE;
/*!40000 ALTER TABLE `ca_schema_updates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_schema_updates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_form_labels`
--

DROP TABLE IF EXISTS `ca_search_form_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_form_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned DEFAULT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_form_id` (`form_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_form_labels`
--

LOCK TABLES `ca_search_form_labels` WRITE;
/*!40000 ALTER TABLE `ca_search_form_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_search_form_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_form_placements`
--

DROP TABLE IF EXISTS `ca_search_form_placements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_form_placements` (
  `placement_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `bundle_name` varchar(255) NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  PRIMARY KEY (`placement_id`),
  KEY `i_bundle_name` (`bundle_name`),
  KEY `i_rank` (`rank`),
  KEY `i_form_id` (`form_id`)
) ENGINE=InnoDB AUTO_INCREMENT=163 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_form_placements`
--

LOCK TABLES `ca_search_form_placements` WRITE;
/*!40000 ALTER TABLE `ca_search_form_placements` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_search_form_placements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_form_type_restrictions`
--

DROP TABLE IF EXISTS `ca_search_form_type_restrictions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_form_type_restrictions` (
  `restriction_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `form_id` int(10) unsigned NOT NULL,
  `include_subtypes` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `settings` longtext NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`restriction_id`),
  KEY `i_form_id` (`form_id`),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_form_type_restrictions`
--

LOCK TABLES `ca_search_form_type_restrictions` WRITE;
/*!40000 ALTER TABLE `ca_search_form_type_restrictions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_search_form_type_restrictions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_forms`
--

DROP TABLE IF EXISTS `ca_search_forms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_forms` (
  `form_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `form_code` varchar(100) DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `is_system` tinyint(3) unsigned NOT NULL,
  `settings` text NOT NULL,
  PRIMARY KEY (`form_id`),
  UNIQUE KEY `u_form_code` (`form_code`),
  KEY `i_user_id` (`user_id`),
  KEY `i_table_num` (`table_num`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_forms`
--

LOCK TABLES `ca_search_forms` WRITE;
/*!40000 ALTER TABLE `ca_search_forms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_search_forms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_forms_x_user_groups`
--

DROP TABLE IF EXISTS `ca_search_forms_x_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_forms_x_user_groups` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_form_id` (`form_id`),
  KEY `i_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_forms_x_user_groups`
--

LOCK TABLES `ca_search_forms_x_user_groups` WRITE;
/*!40000 ALTER TABLE `ca_search_forms_x_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_search_forms_x_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_forms_x_users`
--

DROP TABLE IF EXISTS `ca_search_forms_x_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_forms_x_users` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `form_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  KEY `i_form_id` (`form_id`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_forms_x_users`
--

LOCK TABLES `ca_search_forms_x_users` WRITE;
/*!40000 ALTER TABLE `ca_search_forms_x_users` DISABLE KEYS */;
INSERT INTO `ca_search_forms_x_users` VALUES (2,9,65,2),(3,10,65,2),(4,11,65,2);
/*!40000 ALTER TABLE `ca_search_forms_x_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_indexing_queue`
--

DROP TABLE IF EXISTS `ca_search_indexing_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_indexing_queue` (
  `entry_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `field_data` longtext,
  `reindex` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `changed_fields` longtext,
  `options` longtext,
  `is_unindex` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dependencies` longtext,
  `started_on` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`entry_id`),
  KEY `i_table_num_row_id` (`table_num`,`row_id`),
  KEY `i_started_on` (`started_on`)
) ENGINE=InnoDB AUTO_INCREMENT=105407 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_indexing_queue`
--

LOCK TABLES `ca_search_indexing_queue` WRITE;
/*!40000 ALTER TABLE `ca_search_indexing_queue` DISABLE KEYS */;
INSERT INTO `ca_search_indexing_queue` VALUES (46796,57,263553,NULL,0,NULL,NULL,1,'YTowOnt9',NULL);
INSERT INTO `ca_search_indexing_queue` VALUES (46810,57,237225,NULL,0,NULL,NULL,1,'YTowOnt9',NULL);
INSERT INTO `ca_search_indexing_queue` VALUES (46821,57,237226,NULL,0,NULL,NULL,1,'YTowOnt9',NULL);
INSERT INTO `ca_search_indexing_queue` VALUES (47295,57,280752,NULL,0,NULL,NULL,1,'YTowOnt9',NULL);
/*!40000 ALTER TABLE `ca_search_indexing_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_search_log`
--

DROP TABLE IF EXISTS `ca_search_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_search_log` (
  `search_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `log_datetime` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `search_expression` varchar(1024) NOT NULL,
  `num_hits` int(10) unsigned NOT NULL,
  `form_id` int(10) unsigned DEFAULT NULL,
  `ip_addr` varchar(39) DEFAULT NULL,
  `details` text NOT NULL,
  `execution_time` decimal(7,3) NOT NULL,
  `search_source` varchar(40) NOT NULL,
  PRIMARY KEY (`search_id`),
  KEY `i_log_datetime` (`log_datetime`),
  KEY `i_user_id` (`user_id`),
  KEY `i_form_id` (`form_id`)
) ENGINE=InnoDB AUTO_INCREMENT=1924846 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_search_log`
--

LOCK TABLES `ca_search_log` WRITE;
/*!40000 ALTER TABLE `ca_search_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_search_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_set_item_labels`
--

DROP TABLE IF EXISTS `ca_set_item_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_set_item_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `caption` text NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_set_id` (`item_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2264190 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_set_item_labels`
--

LOCK TABLES `ca_set_item_labels` WRITE;
/*!40000 ALTER TABLE `ca_set_item_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_set_item_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_set_items`
--

DROP TABLE IF EXISTS `ca_set_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_set_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(10) unsigned NOT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `vars` longtext NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `i_set_id` (`set_id`,`deleted`),
  KEY `i_type_id` (`type_id`),
  KEY `i_row_id` (`row_id`),
  KEY `i_table_num` (`table_num`)
) ENGINE=InnoDB AUTO_INCREMENT=2264324 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_set_items`
--

LOCK TABLES `ca_set_items` WRITE;
/*!40000 ALTER TABLE `ca_set_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_set_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_set_labels`
--

DROP TABLE IF EXISTS `ca_set_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_set_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `i_set_id` (`set_id`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6855 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_set_labels`
--

LOCK TABLES `ca_set_labels` WRITE;
/*!40000 ALTER TABLE `ca_set_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_set_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_sets`
--

DROP TABLE IF EXISTS `ca_sets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_sets` (
  `set_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `hier_set_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned NOT NULL,
  `commenting_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `tagging_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating_status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `set_code` varchar(100) DEFAULT NULL,
  `table_num` tinyint(3) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `hier_left` decimal(30,20) unsigned NOT NULL,
  `hier_right` decimal(30,20) unsigned NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`set_id`),
  UNIQUE KEY `u_set_code` (`set_code`),
  KEY `i_user_id` (`user_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_hier_set_id` (`hier_set_id`),
  KEY `i_table_num` (`table_num`),
  KEY `i_set_filter` (`set_id`,`deleted`,`access`),
  CONSTRAINT `fk_ca_sets_parent_id` FOREIGN KEY (`parent_id`) REFERENCES `ca_sets` (`set_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6855 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_sets`
--

LOCK TABLES `ca_sets` WRITE;
/*!40000 ALTER TABLE `ca_sets` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_sets` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_sets_x_user_groups`
--

DROP TABLE IF EXISTS `ca_sets_x_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_sets_x_user_groups` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `sdatetime` int(10) unsigned DEFAULT NULL,
  `edatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`relation_id`),
  KEY `i_set_id` (`set_id`),
  KEY `i_group_id` (`group_id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_sets_x_user_groups`
--

LOCK TABLES `ca_sets_x_user_groups` WRITE;
/*!40000 ALTER TABLE `ca_sets_x_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_sets_x_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_sets_x_users`
--

DROP TABLE IF EXISTS `ca_sets_x_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_sets_x_users` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `set_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `sdatetime` int(10) unsigned DEFAULT NULL,
  `edatetime` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`relation_id`),
  KEY `i_set_id` (`set_id`),
  KEY `i_user_id` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=409 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_sets_x_users`
--

LOCK TABLES `ca_sets_x_users` WRITE;
/*!40000 ALTER TABLE `ca_sets_x_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_sets_x_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_site_page_media`
--

DROP TABLE IF EXISTS `ca_site_page_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_site_page_media` (
  `media_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `page_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `caption` text NOT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `media` longblob NOT NULL,
  `media_metadata` longblob NOT NULL,
  `media_content` longtext NOT NULL,
  `md5` varchar(32) NOT NULL,
  `mimetype` varchar(255) DEFAULT NULL,
  `original_filename` varchar(1024) NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`media_id`),
  UNIQUE KEY `u_idno` (`page_id`,`idno`),
  KEY `page_id` (`page_id`),
  KEY `rank` (`rank`),
  KEY `md5` (`md5`),
  KEY `idno` (`idno`),
  KEY `idno_sort` (`idno_sort`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_site_page_media`
--

LOCK TABLES `ca_site_page_media` WRITE;
/*!40000 ALTER TABLE `ca_site_page_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_site_page_media` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_site_pages`
--

DROP TABLE IF EXISTS `ca_site_pages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_site_pages` (
  `page_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `template_id` int(10) unsigned NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `path` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `keywords` text NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`page_id`),
  KEY `template_id` (`template_id`),
  KEY `i_path` (`path`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_site_pages`
--

LOCK TABLES `ca_site_pages` WRITE;
/*!40000 ALTER TABLE `ca_site_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_site_pages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_site_templates`
--

DROP TABLE IF EXISTS `ca_site_templates`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_site_templates` (
  `template_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `template` longtext NOT NULL,
  `template_code` varchar(100) NOT NULL,
  `tags` longtext NOT NULL,
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`template_id`),
  UNIQUE KEY `u_title` (`title`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_site_templates`
--

LOCK TABLES `ca_site_templates` WRITE;
/*!40000 ALTER TABLE `ca_site_templates` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_site_templates` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_sql_search_ngrams`
--

DROP TABLE IF EXISTS `ca_sql_search_ngrams`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_sql_search_ngrams` (
  `word_id` int(10) unsigned NOT NULL,
  `ngram` char(4) NOT NULL,
  `seq` tinyint(3) unsigned NOT NULL,
  KEY `i_ngram` (`ngram`),
  KEY `i_word_id` (`word_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_sql_search_ngrams`
--

LOCK TABLES `ca_sql_search_ngrams` WRITE;
/*!40000 ALTER TABLE `ca_sql_search_ngrams` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_sql_search_ngrams` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_sql_search_word_index`
--

DROP TABLE IF EXISTS `ca_sql_search_word_index`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_sql_search_word_index` (
  `index_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `field_table_num` tinyint(3) unsigned NOT NULL,
  `field_num` varchar(100) NOT NULL,
  `field_row_id` int(10) unsigned NOT NULL,
  `rel_type_id` smallint(5) unsigned NOT NULL DEFAULT '0',
  `word_id` int(10) unsigned NOT NULL,
  `boost` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `access` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `field_container_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`index_id`),
  KEY `i_row_id` (`row_id`,`table_num`),
  KEY `i_word_id` (`word_id`,`access`),
  KEY `i_field_row_id` (`field_row_id`,`field_table_num`),
  KEY `i_rel_type_id` (`rel_type_id`),
  KEY `i_field_table_num` (`field_table_num`),
  KEY `i_field_num` (`field_num`),
  KEY `i_index_table_num` (`word_id`,`table_num`,`row_id`),
  KEY `i_index_field_table_num` (`word_id`,`table_num`,`field_table_num`,`row_id`),
  KEY `i_index_delete` (`table_num`,`row_id`,`field_table_num`,`field_num`),
) ENGINE=InnoDB AUTO_INCREMENT=135712976 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_sql_search_word_index`
--

LOCK TABLES `ca_sql_search_word_index` WRITE;
/*!40000 ALTER TABLE `ca_sql_search_word_index` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_sql_search_word_index` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_sql_search_words`
--

DROP TABLE IF EXISTS `ca_sql_search_words`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_sql_search_words` (
  `word_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `word` varchar(255) NOT NULL,
  `stem` varchar(255) NOT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`word_id`),
  UNIQUE KEY `u_word` (`word`),
  KEY `i_stem` (`stem`),
  KEY `i_locale_id` (`locale_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2298112 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_sql_search_words`
--

LOCK TABLES `ca_sql_search_words` WRITE;
/*!40000 ALTER TABLE `ca_sql_search_words` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_sql_search_words` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_storage_location_labels`
--

DROP TABLE IF EXISTS `ca_storage_location_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_storage_location_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`location_id`,`name`,`locale_id`,`type_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_location_id` (`location_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_name_sort` (`name_sort`(128)),
) ENGINE=InnoDB AUTO_INCREMENT=213 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_storage_location_labels`
--

LOCK TABLES `ca_storage_location_labels` WRITE;
/*!40000 ALTER TABLE `ca_storage_location_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_storage_location_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_storage_locations`
--

DROP TABLE IF EXISTS `ca_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_storage_locations` (
  `location_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `is_template` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  `color` char(6) DEFAULT NULL,
  `icon` longblob NOT NULL,
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `is_enabled` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`location_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_source_id` (`source_id`),
  KEY `idno` (`idno`),
  KEY `idno_sort` (`idno_sort`),
  KEY `i_type_id` (`type_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_view_count` (`view_count`),
  KEY `i_loc_filter` (`location_id`,`deleted`,`access`),
) ENGINE=InnoDB AUTO_INCREMENT=204 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_storage_locations`
--

LOCK TABLES `ca_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_storage_locations_x_storage_locations`
--

DROP TABLE IF EXISTS `ca_storage_locations_x_storage_locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_storage_locations_x_storage_locations` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_left_id` int(10) unsigned NOT NULL,
  `location_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` text NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`location_left_id`,`location_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_location_left_id` (`location_left_id`),
  KEY `i_location_right_id` (`location_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_storage_locations_x_storage_locations`
--

LOCK TABLES `ca_storage_locations_x_storage_locations` WRITE;
/*!40000 ALTER TABLE `ca_storage_locations_x_storage_locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_storage_locations_x_storage_locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_storage_locations_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_storage_locations_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_storage_locations_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `location_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`location_id`,`item_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_location_id` (`location_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_storage_locations_x_vocabulary_terms`
--

LOCK TABLES `ca_storage_locations_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_storage_locations_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_storage_locations_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_task_queue`
--

DROP TABLE IF EXISTS `ca_task_queue`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_task_queue` (
  `task_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned DEFAULT NULL,
  `row_key` char(32) DEFAULT NULL,
  `entity_key` char(32) DEFAULT NULL,
  `created_on` int(10) unsigned NOT NULL,
  `started_on` int(10) unsigned DEFAULT NULL,
  `completed_on` int(10) unsigned DEFAULT NULL,
  `priority` smallint(5) unsigned NOT NULL DEFAULT '0',
  `handler` varchar(20) NOT NULL,
  `parameters` text NOT NULL,
  `notes` text NOT NULL,
  `error_code` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`task_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_started_on` (`started_on`),
  KEY `i_completed_on` (`completed_on`),
  KEY `i_entity_key` (`entity_key`),
  KEY `i_row_key` (`row_key`),
  KEY `i_error_code` (`error_code`)
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_task_queue`
--

LOCK TABLES `ca_task_queue` WRITE;
/*!40000 ALTER TABLE `ca_task_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_task_queue` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_labels`
--

DROP TABLE IF EXISTS `ca_tour_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tour_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_locale_id` (`tour_id`,`locale_id`),
  KEY `fk_ca_tour_labels_locale_id` (`locale_id`),
  KEY `i_tour_id` (`tour_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_name_sort` (`name_sort`(128)),
  CONSTRAINT `fk_ca_tour_labels_tour_id` FOREIGN KEY (`tour_id`) REFERENCES `ca_tours` (`tour_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_labels`
--

LOCK TABLES `ca_tour_labels` WRITE;
/*!40000 ALTER TABLE `ca_tour_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stop_labels`
--

DROP TABLE IF EXISTS `ca_tour_stop_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stop_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `stop_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `name_sort` varchar(255) NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_locale_id` (`stop_id`,`locale_id`),
  KEY `fk_ca_tour_stop_labels_locale_id` (`locale_id`),
  KEY `i_stop_id` (`stop_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_name_sort` (`name_sort`(128)),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stop_labels`
--

LOCK TABLES `ca_tour_stop_labels` WRITE;
/*!40000 ALTER TABLE `ca_tour_stop_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stop_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops`
--

DROP TABLE IF EXISTS `ca_tour_stops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops` (
  `stop_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `tour_id` int(10) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `idno` varchar(255) NOT NULL,
  `idno_sort` varchar(255) NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  `hier_stop_id` int(10) unsigned NOT NULL,
  `color` char(6) DEFAULT NULL,
  `icon` longblob NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`stop_id`),
  KEY `i_tour_id` (`tour_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_hier_stop_id` (`hier_stop_id`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_idno` (`idno`),
  KEY `i_idno_sort` (`idno_sort`),
  KEY `i_view_count` (`view_count`),
  CONSTRAINT `fk_ca_tour_stops_tour_id` FOREIGN KEY (`tour_id`) REFERENCES `ca_tours` (`tour_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops`
--

LOCK TABLES `ca_tour_stops` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops_x_collections`
--

DROP TABLE IF EXISTS `ca_tour_stops_x_collections`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops_x_collections` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `collection_id` int(10) unsigned NOT NULL,
  `stop_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`collection_id`,`stop_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_collection_id` (`collection_id`),
  KEY `i_stop_id` (`stop_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops_x_collections`
--

LOCK TABLES `ca_tour_stops_x_collections` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops_x_collections` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops_x_collections` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops_x_entities`
--

DROP TABLE IF EXISTS `ca_tour_stops_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `entity_id` int(10) unsigned NOT NULL,
  `stop_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`stop_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_stop_id` (`stop_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops_x_entities`
--

LOCK TABLES `ca_tour_stops_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops_x_objects`
--

DROP TABLE IF EXISTS `ca_tour_stops_x_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops_x_objects` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `object_id` int(10) unsigned NOT NULL,
  `stop_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_id`,`stop_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_object_id` (`object_id`),
  KEY `i_stop_id` (`stop_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops_x_objects`
--

LOCK TABLES `ca_tour_stops_x_objects` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops_x_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops_x_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops_x_occurrences`
--

DROP TABLE IF EXISTS `ca_tour_stops_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `occurrence_id` int(10) unsigned NOT NULL,
  `stop_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`stop_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_stop_id` (`stop_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops_x_occurrences`
--

LOCK TABLES `ca_tour_stops_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops_x_places`
--

DROP TABLE IF EXISTS `ca_tour_stops_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `place_id` int(10) unsigned NOT NULL,
  `stop_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`stop_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_place_id` (`place_id`),
  KEY `i_stop_id` (`stop_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops_x_places`
--

LOCK TABLES `ca_tour_stops_x_places` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops_x_tour_stops`
--

DROP TABLE IF EXISTS `ca_tour_stops_x_tour_stops`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops_x_tour_stops` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `stop_left_id` int(10) unsigned NOT NULL,
  `stop_right_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` text NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`stop_left_id`,`stop_right_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_stop_left_id` (`stop_left_id`),
  KEY `i_stop_right_id` (`stop_right_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops_x_tour_stops`
--

LOCK TABLES `ca_tour_stops_x_tour_stops` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops_x_tour_stops` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops_x_tour_stops` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tour_stops_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_tour_stops_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tour_stops_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `item_id` int(10) unsigned NOT NULL,
  `stop_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`item_id`,`stop_id`,`type_id`,`sdatetime`,`edatetime`),
  KEY `i_item_id` (`item_id`),
  KEY `i_stop_id` (`stop_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tour_stops_x_vocabulary_terms`
--

LOCK TABLES `ca_tour_stops_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_tour_stops_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tour_stops_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_tours`
--

DROP TABLE IF EXISTS `ca_tours`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_tours` (
  `tour_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tour_code` varchar(100) NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `color` char(6) DEFAULT NULL,
  `icon` longblob NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `view_count` int(10) unsigned NOT NULL DEFAULT '0',
  `user_id` int(10) unsigned DEFAULT NULL,
  `source_id` int(10) unsigned DEFAULT NULL,
  `source_info` longtext NOT NULL,
  PRIMARY KEY (`tour_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_tour_code` (`tour_code`),
  KEY `i_source_id` (`source_id`),
  KEY `i_view_count` (`view_count`),
  CONSTRAINT `fk_ca_tours_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_tours`
--

LOCK TABLES `ca_tours` WRITE;
/*!40000 ALTER TABLE `ca_tours` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_tours` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_groups`
--

DROP TABLE IF EXISTS `ca_user_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_groups` (
  `group_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `parent_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `vars` text NOT NULL,
  `hier_left` decimal(30,20) NOT NULL,
  `hier_right` decimal(30,20) NOT NULL,
  PRIMARY KEY (`group_id`),
  UNIQUE KEY `u_name` (`name`),
  UNIQUE KEY `u_code` (`code`),
  KEY `i_hier_left` (`hier_left`),
  KEY `i_hier_right` (`hier_right`),
  KEY `i_parent_id` (`parent_id`),
  KEY `i_user_id` (`user_id`),
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_groups`
--

LOCK TABLES `ca_user_groups` WRITE;
/*!40000 ALTER TABLE `ca_user_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_notes`
--

DROP TABLE IF EXISTS `ca_user_notes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_notes` (
  `note_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `bundle_name` varchar(255) NOT NULL,
  `note` longtext NOT NULL,
  `created_on` int(10) unsigned NOT NULL,
  PRIMARY KEY (`note_id`),
  KEY `i_row_id` (`row_id`,`table_num`),
  KEY `i_user_id` (`user_id`),
  KEY `i_bundle_name` (`bundle_name`),
  CONSTRAINT `fk_ca_user_notes_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_notes`
--

LOCK TABLES `ca_user_notes` WRITE;
/*!40000 ALTER TABLE `ca_user_notes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_notes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_representation_annotation_labels`
--

DROP TABLE IF EXISTS `ca_user_representation_annotation_labels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_representation_annotation_labels` (
  `label_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned NOT NULL,
  `type_id` int(10) unsigned DEFAULT NULL,
  `name` text NOT NULL,
  `name_sort` text NOT NULL,
  `source_info` longtext NOT NULL,
  `is_preferred` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`label_id`),
  UNIQUE KEY `u_all` (`name`(128),`locale_id`,`type_id`,`annotation_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_name` (`name`(128)),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_name_sort` (`name_sort`(128)),
  KEY `i_type_id` (`type_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_representation_annotation_labels`
--

LOCK TABLES `ca_user_representation_annotation_labels` WRITE;
/*!40000 ALTER TABLE `ca_user_representation_annotation_labels` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_representation_annotation_labels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_representation_annotations`
--

DROP TABLE IF EXISTS `ca_user_representation_annotations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_representation_annotations` (
  `annotation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `representation_id` int(10) unsigned NOT NULL,
  `locale_id` smallint(5) unsigned DEFAULT NULL,
  `user_id` int(10) unsigned DEFAULT NULL,
  `type_code` varchar(30) NOT NULL,
  `props` longtext NOT NULL,
  `preview` longblob NOT NULL,
  `source_info` longtext NOT NULL,
  `access` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`annotation_id`),
  KEY `i_representation_id` (`representation_id`),
  KEY `i_locale_id` (`locale_id`),
  KEY `i_user_id` (`user_id`),
  CONSTRAINT `fk_ca_urep_annot_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_representation_annotations`
--

LOCK TABLES `ca_user_representation_annotations` WRITE;
/*!40000 ALTER TABLE `ca_user_representation_annotations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_representation_annotations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_representation_annotations_x_entities`
--

DROP TABLE IF EXISTS `ca_user_representation_annotations_x_entities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_representation_annotations_x_entities` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `entity_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`entity_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_entity_id` (`entity_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_representation_annotations_x_entities`
--

LOCK TABLES `ca_user_representation_annotations_x_entities` WRITE;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_entities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_entities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_representation_annotations_x_objects`
--

DROP TABLE IF EXISTS `ca_user_representation_annotations_x_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_representation_annotations_x_objects` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `object_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`object_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_object_id` (`object_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_representation_annotations_x_objects`
--

LOCK TABLES `ca_user_representation_annotations_x_objects` WRITE;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_representation_annotations_x_occurrences`
--

DROP TABLE IF EXISTS `ca_user_representation_annotations_x_occurrences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_representation_annotations_x_occurrences` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `occurrence_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`occurrence_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_occurrence_id` (`occurrence_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_representation_annotations_x_occurrences`
--

LOCK TABLES `ca_user_representation_annotations_x_occurrences` WRITE;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_occurrences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_occurrences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_representation_annotations_x_places`
--

DROP TABLE IF EXISTS `ca_user_representation_annotations_x_places`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_representation_annotations_x_places` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `place_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`place_id`,`type_id`,`annotation_id`,`sdatetime`,`edatetime`),
  KEY `i_place_id` (`place_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_representation_annotations_x_places`
--

LOCK TABLES `ca_user_representation_annotations_x_places` WRITE;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_places` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_places` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_representation_annotations_x_vocabulary_terms`
--

DROP TABLE IF EXISTS `ca_user_representation_annotations_x_vocabulary_terms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_representation_annotations_x_vocabulary_terms` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `annotation_id` int(10) unsigned NOT NULL,
  `type_id` smallint(5) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `source_info` longtext NOT NULL,
  `sdatetime` decimal(30,20) DEFAULT NULL,
  `edatetime` decimal(30,20) DEFAULT NULL,
  `label_left_id` int(10) unsigned DEFAULT NULL,
  `label_right_id` int(10) unsigned DEFAULT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`type_id`,`annotation_id`,`sdatetime`,`edatetime`,`item_id`),
  KEY `i_item_id` (`item_id`),
  KEY `i_annotation_id` (`annotation_id`),
  KEY `i_type_id` (`type_id`),
  KEY `i_label_left_id` (`label_left_id`),
  KEY `i_label_right_id` (`label_right_id`),
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_representation_annotations_x_vocabulary_terms`
--

LOCK TABLES `ca_user_representation_annotations_x_vocabulary_terms` WRITE;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_vocabulary_terms` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_representation_annotations_x_vocabulary_terms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_roles`
--

DROP TABLE IF EXISTS `ca_user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_roles` (
  `role_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `code` varchar(20) NOT NULL,
  `description` text NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `vars` longtext NOT NULL,
  `field_access` longtext NOT NULL,
  PRIMARY KEY (`role_id`),
  UNIQUE KEY `u_name` (`name`),
  UNIQUE KEY `u_code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_roles`
--

LOCK TABLES `ca_user_roles` WRITE;
/*!40000 ALTER TABLE `ca_user_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_user_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_sort_items`
--

DROP TABLE IF EXISTS `ca_user_sort_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_sort_items` (
  `item_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `sort_id` int(10) unsigned NOT NULL,
  `bundle_name` varchar(255) NOT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_id`),
  KEY `fk_ca_user_sort_items_sort_id` (`sort_id`),
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_sort_items`
--

LOCK TABLES `ca_user_sort_items` WRITE;
/*!40000 ALTER TABLE `ca_user_sort_items` DISABLE KEYS */;
INSERT INTO `ca_user_sort_items` VALUES (1,1,'_natural',1),(2,1,'_natural',2),(3,1,'_natural',3);
/*!40000 ALTER TABLE `ca_user_sort_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_user_sorts`
--

DROP TABLE IF EXISTS `ca_user_sorts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_user_sorts` (
  `sort_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `settings` longtext NOT NULL,
  `sort_type` char(1) DEFAULT NULL,
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `deleted` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`sort_id`),
  UNIQUE KEY `u_guid` (`table_num`,`name`),
  KEY `i_table_num` (`table_num`),
  KEY `i_user_id` (`user_id`),
  CONSTRAINT `fk_ca_user_sorts_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_user_sorts`
--

LOCK TABLES `ca_user_sorts` WRITE;
/*!40000 ALTER TABLE `ca_user_sorts` DISABLE KEYS */;
INSERT INTO `ca_user_sorts` VALUES (1,57,65,'malawneh','Tjs=',NULL,0,1);
/*!40000 ALTER TABLE `ca_user_sorts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_users`
--

DROP TABLE IF EXISTS `ca_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_users` (
  `user_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_name` varchar(255) NOT NULL,
  `userclass` tinyint(3) unsigned NOT NULL,
  `password` varchar(100) NOT NULL,
  `fname` varchar(255) NOT NULL,
  `lname` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `sms_number` varchar(30) NOT NULL,
  `vars` longtext NOT NULL,
  `volatile_vars` text NOT NULL,
  `active` tinyint(3) unsigned NOT NULL,
  `confirmed_on` int(10) unsigned DEFAULT NULL,
  `confirmation_key` char(32) DEFAULT NULL,
  `registered_on` int(10) unsigned DEFAULT NULL,
  `entity_id` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `u_user_name` (`user_name`),
  UNIQUE KEY `u_confirmation_key` (`confirmation_key`),
  KEY `i_userclass` (`userclass`),
  KEY `i_entity_id` (`entity_id`),
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_users`
--

LOCK TABLES `ca_users` WRITE;
/*!40000 ALTER TABLE `ca_users` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_users_x_groups`
--

DROP TABLE IF EXISTS `ca_users_x_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_users_x_groups` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `group_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`user_id`,`group_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_group_id` (`group_id`),
) ENGINE=InnoDB AUTO_INCREMENT=162 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_users_x_groups`
--

LOCK TABLES `ca_users_x_groups` WRITE;
/*!40000 ALTER TABLE `ca_users_x_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_users_x_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_users_x_roles`
--

DROP TABLE IF EXISTS `ca_users_x_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_users_x_roles` (
  `relation_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(10) unsigned NOT NULL,
  `role_id` smallint(5) unsigned NOT NULL,
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`relation_id`),
  UNIQUE KEY `u_all` (`user_id`,`role_id`),
  KEY `i_user_id` (`user_id`),
  KEY `i_role_id` (`role_id`),
  CONSTRAINT `fk_ca_users_x_roles_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=145 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_users_x_roles`
--

LOCK TABLES `ca_users_x_roles` WRITE;
/*!40000 ALTER TABLE `ca_users_x_roles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_users_x_roles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ca_watch_list`
--

DROP TABLE IF EXISTS `ca_watch_list`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ca_watch_list` (
  `watch_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `table_num` tinyint(3) unsigned NOT NULL,
  `row_id` int(10) unsigned NOT NULL,
  `user_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`watch_id`),
  UNIQUE KEY `u_all` (`row_id`,`table_num`,`user_id`),
  KEY `i_row_id` (`row_id`,`table_num`),
  KEY `i_user_id` (`user_id`),
  CONSTRAINT `fk_ca_watch_list_user_id` FOREIGN KEY (`user_id`) REFERENCES `ca_users` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ca_watch_list`
--

LOCK TABLES `ca_watch_list` WRITE;
/*!40000 ALTER TABLE `ca_watch_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `ca_watch_list` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `datemp_table`
--

DROP TABLE IF EXISTS `datemp_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `datemp_table` (
  `object_id` int(10) unsigned DEFAULT NULL,
  `label_id` int(10) unsigned DEFAULT NULL,
  `name` varchar(1024) DEFAULT NULL,
  `value_longtext1` longtext,
  `value_id` int(10) unsigned DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `datemp_table`
--

LOCK TABLES `datemp_table` WRITE;
/*!40000 ALTER TABLE `datemp_table` DISABLE KEYS */;
/*!40000 ALTER TABLE `datemp_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `temptable`
--

DROP TABLE IF EXISTS `temptable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `temptable` (
  `object_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temptable`
--

LOCK TABLES `temptable` WRITE;
/*!40000 ALTER TABLE `temptable` DISABLE KEYS */;
/*!40000 ALTER TABLE `temptable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-26  3:41:01
