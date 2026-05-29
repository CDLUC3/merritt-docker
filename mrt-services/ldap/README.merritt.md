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

Modify records
```
bin/ldapmodify -h localhost -p 1389 -D "$ROOT_USER_DN" --bindPassword $ROOT_PASSWORD \
  -f /opt/import/sample-modify.ldif -v
```