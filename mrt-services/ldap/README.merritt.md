## Status
```
bin/status --bindDN "cn=Directory Manager" --bindPassword $ROOT_PASSWORD
```

## List Users

```
bin/ldapsearch -h localhost -p 1389 -b "" "(objectclass=inetOrgPerson)"
```

## List Collections

```
bin/ldapsearch -h localhost -p 1389 -b "" "(objectclass=merrittClass)"
```

