# Key LDAP Use Cases to Test

## Build

```
docker compose build
```

## Use Cases
- LDAP starts with an empty repo and defaults to importing our barebones.ldif file
- LDAP starts with an empty repo and loads a designated input file (ie S3 ldif backup)
- LDAP restarts and re-uses data residing on a volume

## Bare Bones Import

```
docker compose -f docker-compose.ephemeral.yml up -d
```

### Test the service
```
docker compose -f docker-compose.ephemeral.yml exec ldap ./merritt-status.sh
```

```
docker compose -f docker-compose.ephemeral.yml exec ldap ./merritt-users.sh
```

Confirm the 2 default users
- merritt-test
- anonymous


```
docker compose -f docker-compose.ephemeral.yml exec ldap ./merritt-collections.sh
```

### Test completion

```
docker compose -f docker-compose.ephemeral.yml down
```

## Simpsons Users Import

```
docker compose -f docker-compose.simpsons.yml up -d
```

### Test the service

```
docker compose -f docker-compose.simpsons.yml exec ldap ./merritt-users.sh
```

In addition to the 2 default users
- merritt-test
- anonymous

Confirm the addition of
- Lisa Simpson
- Ned Flanders

### Modify records

```
bin/ldapmodify -h localhost -p 1389 -D "$ROOT_USER_DN" --bindPassword $ROOT_PASSWORD \
  -f /opt/import/sample-modify.ldif -v
```

```
docker compose -f docker-compose.simpsons.yml exec ldap ./merritt-users.sh
```

Confirm the following modifications
- Ned Flanders --> Edward Flanders
- Crusty Clown

```
bin/export-ldif --backendID userRoot --bindPassword $ROOT_PASSWORD -l simpsons.export.ldif
```

```
docker compose cp ldap:/opt/opendj/data/simpsons.export.ldif simpsons.export.ldif
```

### Restart the stack

```
docker compose -f docker-compose.simpsons.yml down
```


```
docker compose -f docker-compose.simpsons.yml up -d
```

### Test the service

```
docker compose -f docker-compose.simpsons.yml exec ldap ./merritt-users.sh
```

The stack will now contain 4 users
- merritt-test
- anonymous
- Lisa Simpson
- Ned Flanders

