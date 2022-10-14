## The table `ca_object_representations` seems to have the names of the files that we want to match to.

Eric and Terry met.  We will not pursue working with the database on its own.  A consultation will be made to determine if there is better information to extract.

Perhaps a data export could be provided.  It is unclear if this was the source for the mods files.

## Analysis steps



```
cat daily_da_ca_2022-07-26_03h32m_Tuesday.sql | egrep "^.{0,100}$" > schema.sql
grep -n "CREATE TABLE" *
egrep "CREATE TABLE|varchar|text" schema.sql |less
sed -n 13178,13343p daily_da_ca_2022-07-26_03h32m_Tuesday.sql > obj.sql
```



```
25:CREATE TABLE `ca_acl` (
62:CREATE TABLE `ca_application_vars` (
84:CREATE TABLE `ca_attribute_value_multifiles` (
114:CREATE TABLE `ca_attribute_values` (
509:CREATE TABLE `ca_attributes` (
608:CREATE TABLE `ca_batch_log` (
640:CREATE TABLE `ca_batch_log_items` (
738:CREATE TABLE `ca_bookmark_folders` (
764:CREATE TABLE `ca_bookmarks` (
794:CREATE TABLE `ca_bundle_display_labels` (
826:CREATE TABLE `ca_bundle_display_placements` (
856:CREATE TABLE `ca_bundle_display_type_restrictions` (
888:CREATE TABLE `ca_bundle_displays` (
920:CREATE TABLE `ca_bundle_displays_x_user_groups` (
948:CREATE TABLE `ca_bundle_displays_x_users` (
976:CREATE TABLE `ca_change_log` (
2417:CREATE TABLE `ca_change_log_snapshots` (
6394:CREATE TABLE `ca_change_log_subjects` (
6823:CREATE TABLE `ca_collection_labels` (
6862:CREATE TABLE `ca_collections` (
6921:CREATE TABLE `ca_collections_x_collections` (
6964:CREATE TABLE `ca_collections_x_storage_locations` (
7008:CREATE TABLE `ca_collections_x_vocabulary_terms` (
7050:CREATE TABLE `ca_data_exporter_items` (
7090:CREATE TABLE `ca_data_exporter_labels` (
7126:CREATE TABLE `ca_data_exporters` (
7154:CREATE TABLE `ca_data_import_event_log` (
7186:CREATE TABLE `ca_data_import_events` (
7216:CREATE TABLE `ca_data_import_items` (
7280:CREATE TABLE `ca_data_importer_groups` (
7310:CREATE TABLE `ca_data_importer_items` (
7342:CREATE TABLE `ca_data_importer_labels` (
7378:CREATE TABLE `ca_data_importer_log` (
7411:CREATE TABLE `ca_data_importer_log_items` (
7443:CREATE TABLE `ca_data_importers` (
7474:CREATE TABLE `ca_download_log` (
7510:CREATE TABLE `ca_editor_ui_bundle_placements` (
7540:CREATE TABLE `ca_editor_ui_labels` (
7569:CREATE TABLE `ca_editor_ui_screen_labels` (
7598:CREATE TABLE `ca_editor_ui_screen_type_restrictions` (
7630:CREATE TABLE `ca_editor_ui_screens` (
7667:CREATE TABLE `ca_editor_ui_screens_x_roles` (
7695:CREATE TABLE `ca_editor_ui_screens_x_user_groups` (
7723:CREATE TABLE `ca_editor_ui_screens_x_users` (
7751:CREATE TABLE `ca_editor_ui_type_restrictions` (
7783:CREATE TABLE `ca_editor_uis` (
7814:CREATE TABLE `ca_editor_uis_x_roles` (
7842:CREATE TABLE `ca_editor_uis_x_user_groups` (
7869:CREATE TABLE `ca_editor_uis_x_users` (
7897:CREATE TABLE `ca_entities` (
7959:CREATE TABLE `ca_entities_x_collections` (
8002:CREATE TABLE `ca_entities_x_entities` (
8045:CREATE TABLE `ca_entities_x_occurrences` (
8088:CREATE TABLE `ca_entities_x_places` (
8131:CREATE TABLE `ca_entities_x_storage_locations` (
8173:CREATE TABLE `ca_entities_x_vocabulary_terms` (
8215:CREATE TABLE `ca_entity_labels` (
8262:CREATE TABLE `ca_eventlog` (
8293:CREATE TABLE `ca_groups_x_roles` (
8324:CREATE TABLE `ca_guids` (
8980:CREATE TABLE `ca_history_tracking_current_values` (
9019:CREATE TABLE `ca_ips` (
9051:CREATE TABLE `ca_item_comments` (
9099:CREATE TABLE `ca_item_tags` (
9125:CREATE TABLE `ca_items_x_tags` (
9166:CREATE TABLE `ca_list_item_labels` (
9208:CREATE TABLE `ca_list_items` (
9265:CREATE TABLE `ca_list_items_x_list_items` (
9307:CREATE TABLE `ca_list_labels` (
9339:CREATE TABLE `ca_lists` (
9369:CREATE TABLE `ca_loan_labels` (
9407:CREATE TABLE `ca_loans` (
9461:CREATE TABLE `ca_loans_x_collections` (
9504:CREATE TABLE `ca_loans_x_entities` (
9547:CREATE TABLE `ca_loans_x_loans` (
9589:CREATE TABLE `ca_loans_x_movements` (
9631:CREATE TABLE `ca_loans_x_object_lots` (
9673:CREATE TABLE `ca_loans_x_object_representations` (
9716:CREATE TABLE `ca_loans_x_objects` (
9758:CREATE TABLE `ca_loans_x_occurrences` (
9800:CREATE TABLE `ca_loans_x_places` (
9842:CREATE TABLE `ca_loans_x_storage_locations` (
9885:CREATE TABLE `ca_loans_x_vocabulary_terms` (
9927:CREATE TABLE `ca_locales` (
9956:CREATE TABLE `ca_media_content_locations` (
9984:CREATE TABLE `ca_media_replication_status_check` (
10012:CREATE TABLE `ca_metadata_alert_rule_labels` (
10043:CREATE TABLE `ca_metadata_alert_rule_type_restrictions` (
10074:CREATE TABLE `ca_metadata_alert_rules` (
10101:CREATE TABLE `ca_metadata_alert_rules_x_user_groups` (
10128:CREATE TABLE `ca_metadata_alert_rules_x_users` (
10155:CREATE TABLE `ca_metadata_alert_triggers` (
10186:CREATE TABLE `ca_metadata_dictionary_entries` (
10213:CREATE TABLE `ca_metadata_dictionary_entry_labels` (
10244:CREATE TABLE `ca_metadata_dictionary_rule_violations` (
10276:CREATE TABLE `ca_metadata_dictionary_rules` (
10307:CREATE TABLE `ca_metadata_element_labels` (
10339:CREATE TABLE `ca_metadata_elements` (
10380:CREATE TABLE `ca_metadata_type_restrictions` (
10414:CREATE TABLE `ca_movement_labels` (
10451:CREATE TABLE `ca_movements` (
10495:CREATE TABLE `ca_movements_x_collections` (
10537:CREATE TABLE `ca_movements_x_entities` (
10579:CREATE TABLE `ca_movements_x_movements` (
10621:CREATE TABLE `ca_movements_x_object_lots` (
10663:CREATE TABLE `ca_movements_x_object_representations` (
10706:CREATE TABLE `ca_movements_x_objects` (
10748:CREATE TABLE `ca_movements_x_occurrences` (
10790:CREATE TABLE `ca_movements_x_places` (
10832:CREATE TABLE `ca_movements_x_storage_locations` (
10874:CREATE TABLE `ca_movements_x_vocabulary_terms` (
10916:CREATE TABLE `ca_multipart_idno_sequences` (
10942:CREATE TABLE `ca_notification_subjects` (
10976:CREATE TABLE `ca_notifications` (
11007:CREATE TABLE `ca_object_checkouts` (
11053:CREATE TABLE `ca_object_labels` (
11148:CREATE TABLE `ca_object_lot_labels` (
11186:CREATE TABLE `ca_object_lots` (
11235:CREATE TABLE `ca_object_lots_x_collections` (
11277:CREATE TABLE `ca_object_lots_x_entities` (
11319:CREATE TABLE `ca_object_lots_x_object_lots` (
11361:CREATE TABLE `ca_object_lots_x_object_representations` (
11404:CREATE TABLE `ca_object_lots_x_occurrences` (
11446:CREATE TABLE `ca_object_lots_x_places` (
11488:CREATE TABLE `ca_object_lots_x_storage_locations` (
11530:CREATE TABLE `ca_object_lots_x_vocabulary_terms` (
11572:CREATE TABLE `ca_object_representation_captions` (
11601:CREATE TABLE `ca_object_representation_labels` (
11656:CREATE TABLE `ca_object_representation_multifiles` (
11728:CREATE TABLE `ca_object_representations` (
12877:CREATE TABLE `ca_object_representations_x_collections` (
12921:CREATE TABLE `ca_object_representations_x_entities` (
12964:CREATE TABLE `ca_object_representations_x_object_representations` (
13006:CREATE TABLE `ca_object_representations_x_occurrences` (
13049:CREATE TABLE `ca_object_representations_x_places` (
13092:CREATE TABLE `ca_object_representations_x_storage_locations` (
13135:CREATE TABLE `ca_object_representations_x_vocabulary_terms` (
13178:CREATE TABLE `ca_objects` (
13344:CREATE TABLE `ca_objects_x_collections` (
13404:CREATE TABLE `ca_objects_x_entities` (
13470:CREATE TABLE `ca_objects_x_object_representations` (
13513:CREATE TABLE `ca_objects_x_objects` (
13556:CREATE TABLE `ca_objects_x_occurrences` (
13599:CREATE TABLE `ca_objects_x_places` (
13647:CREATE TABLE `ca_objects_x_storage_locations` (
13690:CREATE TABLE `ca_objects_x_vocabulary_terms` (
13733:CREATE TABLE `ca_occurrence_labels` (
13772:CREATE TABLE `ca_occurrences` (
13827:CREATE TABLE `ca_occurrences_x_collections` (
13869:CREATE TABLE `ca_occurrences_x_occurrences` (
13911:CREATE TABLE `ca_occurrences_x_storage_locations` (
13953:CREATE TABLE `ca_occurrences_x_vocabulary_terms` (
13995:CREATE TABLE `ca_persistent_cache` (
14024:CREATE TABLE `ca_place_labels` (
14063:CREATE TABLE `ca_places` (
14126:CREATE TABLE `ca_places_x_collections` (
14169:CREATE TABLE `ca_places_x_occurrences` (
14212:CREATE TABLE `ca_places_x_places` (
14254:CREATE TABLE `ca_places_x_storage_locations` (
14296:CREATE TABLE `ca_places_x_vocabulary_terms` (
14338:CREATE TABLE `ca_relationship_relationships` (
14372:CREATE TABLE `ca_relationship_type_labels` (
14407:CREATE TABLE `ca_relationship_types` (
14451:CREATE TABLE `ca_replication_log` (
14478:CREATE TABLE `ca_representation_annotation_labels` (
14516:CREATE TABLE `ca_representation_annotations` (
14555:CREATE TABLE `ca_representation_annotations_x_entities` (
14597:CREATE TABLE `ca_representation_annotations_x_objects` (
14639:CREATE TABLE `ca_representation_annotations_x_occurrences` (
14681:CREATE TABLE `ca_representation_annotations_x_places` (
14723:CREATE TABLE `ca_representation_annotations_x_vocabulary_terms` (
14765:CREATE TABLE `ca_schema_updates` (
14789:CREATE TABLE `ca_search_form_labels` (
14821:CREATE TABLE `ca_search_form_placements` (
14851:CREATE TABLE `ca_search_form_type_restrictions` (
14882:CREATE TABLE `ca_search_forms` (
14913:CREATE TABLE `ca_search_forms_x_user_groups` (
14940:CREATE TABLE `ca_search_forms_x_users` (
14968:CREATE TABLE `ca_search_indexing_queue` (
16893:CREATE TABLE `ca_search_log` (
17095:CREATE TABLE `ca_set_item_labels` (
17182:CREATE TABLE `ca_set_items` (
17296:CREATE TABLE `ca_set_labels` (
17324:CREATE TABLE `ca_sets` (
17372:CREATE TABLE `ca_sets_x_user_groups` (
17402:CREATE TABLE `ca_sets_x_users` (
17432:CREATE TABLE `ca_site_page_media` (
17474:CREATE TABLE `ca_site_pages` (
17507:CREATE TABLE `ca_site_templates` (
17536:CREATE TABLE `ca_sql_search_ngrams` (
17561:CREATE TABLE `ca_sql_search_word_index` (
24099:CREATE TABLE `ca_sql_search_words` (
24248:CREATE TABLE `ca_storage_location_labels` (
24287:CREATE TABLE `ca_storage_locations` (
24339:CREATE TABLE `ca_storage_locations_x_storage_locations` (
24381:CREATE TABLE `ca_storage_locations_x_vocabulary_terms` (
24423:CREATE TABLE `ca_task_queue` (
24463:CREATE TABLE `ca_tour_labels` (
24496:CREATE TABLE `ca_tour_stop_labels` (
24529:CREATE TABLE `ca_tour_stops` (
24577:CREATE TABLE `ca_tour_stops_x_collections` (
24619:CREATE TABLE `ca_tour_stops_x_entities` (
24661:CREATE TABLE `ca_tour_stops_x_objects` (
24703:CREATE TABLE `ca_tour_stops_x_occurrences` (
24745:CREATE TABLE `ca_tour_stops_x_places` (
24787:CREATE TABLE `ca_tour_stops_x_tour_stops` (
24829:CREATE TABLE `ca_tour_stops_x_vocabulary_terms` (
24871:CREATE TABLE `ca_tours` (
24911:CREATE TABLE `ca_user_groups` (
24950:CREATE TABLE `ca_user_notes` (
24982:CREATE TABLE `ca_user_representation_annotation_labels` (
25020:CREATE TABLE `ca_user_representation_annotations` (
25057:CREATE TABLE `ca_user_representation_annotations_x_entities` (
25099:CREATE TABLE `ca_user_representation_annotations_x_objects` (
25141:CREATE TABLE `ca_user_representation_annotations_x_occurrences` (
25183:CREATE TABLE `ca_user_representation_annotations_x_places` (
25225:CREATE TABLE `ca_user_representation_annotations_x_vocabulary_terms` (
25267:CREATE TABLE `ca_user_roles` (
25298:CREATE TABLE `ca_user_sort_items` (
25326:CREATE TABLE `ca_user_sorts` (
25360:CREATE TABLE `ca_users` (
25420:CREATE TABLE `ca_users_x_groups` (
25450:CREATE TABLE `ca_users_x_roles` (
25481:CREATE TABLE `ca_watch_list` (
25511:CREATE TABLE `datemp_table` (
25537:CREATE TABLE `temptable` 
```