## List Users

```
bin/ldapsearch -h localhost -p 1389 -b "" "(objectclass=inetOrgPerson)"
```

## List Collections

```
bin/ldapsearch -h localhost -p 1389 -b "" "(objectclass=merrittClass)"
```

## Init Script

```
./bin/import-ldif \
  --hostname localhost \
  --port 4444 \
  --bindDN "cn=Directory Manager" \
  --bindPassword $ROOT_PASSWORD \
  --backendID userRoot \
  --includeBranch "ou=uc3,dc=cdlib,dc=org" \
  --trustAll \
  --ldifFile /opt/barebones.ldif
```