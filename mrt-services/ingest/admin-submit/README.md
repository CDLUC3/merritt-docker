This folder is intended to hold manifests and scripts to submit admin objects.

```
select concat('obj_',id), ark, erc_what from inv_objects
union
select concat('coll_',id), ark, name from inv_collections
union
select concat('own_',id), ark, name from inv_owners;
```