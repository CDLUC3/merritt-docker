# Key LDAP Use Cases to Test

## Build

```bash
docker compose build
```

## Use Cases
- LDAP restarts and re-uses data residing on a volume
- LDAP starts with an empty repo and loads a designated input file (ie S3 ldif backup)
- LDAP starts with an empty repo and defaults to importing our barebones.ldif file

## Bare Bones Import

```bash
docker compose -f docker-compose.ephemeral.yml up -d
```

### Test the service

```bash
docker compose -f docker-compose.ephemeral.yml exec ldap ./merritt-status.sh
```

```bash
docker compose -f docker-compose.ephemeral.yml exec ldap ./merritt-users.sh
```

Confirm the 2 default users
- merritt-test
- anonymous


```bash
docker compose -f docker-compose.ephemeral.yml exec ldap ./merritt-collections.sh
```

### Test completion

```bash
docker compose -f docker-compose.ephemeral.yml down
```

## Simpsons Users Import

```bash
docker compose -f docker-compose.simpsons.yml up -d
```

### Test the service

```bash
docker compose -f docker-compose.simpsons.yml exec ldap ./merritt-users.sh
```

In addition to the 2 default users
- merritt-test
- anonymous

Confirm the addition of
- Lisa Simpson
- Ned Flanders

### Modify records

```bash
docker compose -f docker-compose.simpsons.yml exec ldap /bin/bash
```

```bash
# ~~ in container
bin/ldapmodify -h localhost -p 1389 -D "$ROOT_USER_DN" --bindPassword $ROOT_PASSWORD \
  -f /opt/import/sample-modify.ldif -v
exit
```

```bash
docker compose -f docker-compose.simpsons.yml exec ldap ./merritt-users.sh
```

Confirm the following modifications
- Ned Flanders --> Edward Flanders
- Crusty Clown


### Create Export File (for future testing)

```bash
docker compose -f docker-compose.simpsons.yml exec ldap /bin/bash
```

```bash
# ~~ in container
bin/export-ldif --backendID userRoot --bindPassword $ROOT_PASSWORD -l simpsons.export.ldif
exit
```

```bash
docker compose cp ldap:/opt/opendj/data/simpsons.export.ldif simpsons.export.ldif
```

### Restart the stack

```bash
docker compose -f docker-compose.simpsons.yml down
```

```bash
docker compose -f docker-compose.simpsons.yml up -d
```

### Test the service

```bash
docker compose -f docker-compose.simpsons.yml exec ldap ./merritt-users.sh
```

The stack will now contain 4 users
- merritt-test
- anonymous
- Lisa Simpson
- Ned Flanders

### Stop the stack

```bash
docker compose -f docker-compose.simpsons.yml down
```


## Simpsons Users Import with Persistence

```bash
docker compose -f docker-compose.simpsons.persist.yml up -d
```

### Test the service

```bash
docker compose -f docker-compose.simpsons.persist.yml exec ldap ./merritt-users.sh
```

In addition to the 2 default users
- merritt-test
- anonymous

Confirm the addition of
- Lisa Simpson
- Ned Flanders

### Modify records

```bash
docker compose -f docker-compose.simpsons.persist.yml exec ldap /bin/bash
```

```bash
# ~~ in container
bin/ldapmodify -h localhost -p 1389 -D "$ROOT_USER_DN" \
  --bindPassword $ROOT_PASSWORD \
  -f /opt/import/sample-modify.ldif -v
exit
```

```bash
docker compose -f docker-compose.simpsons.persist.yml exec ldap ./merritt-users.sh
```

Confirm the following modifications
- Ned Flanders --> Edward Flanders
- Crusty Clown


### Restart the stack

```bash
docker compose -f docker-compose.simpsons.persist.yml down
```

```bash
docker compose -f docker-compose.simpsons.persist.yml up -d
```

### Test the service

```bash
docker compose -f docker-compose.simpsons.persist.yml exec ldap ./merritt-users.sh
```

The stack will now contain 5 users
- merritt-test
- anonymous
- Lisa Simpson
- Edward Flanders
- Crusty Clown

### Stop the service and delete the persisted content

```bash
docker compose -f docker-compose.simpsons.persist.yml down --volumes
```


## LDAP Replication

```bash
docker compose -f docker-compose.replication.yml up -d
```

### Verify users imported into each instance (note differences)

Simpsons data loaded into ldap
```bash
docker compose -f docker-compose.replication.yml exec ldap ./merritt-users.sh
```

No users loaded into ldapreplica
```bash
docker compose -f docker-compose.replication.yml exec ldapreplica ./merritt-users.sh
docker compose -f docker-compose.replication.yml exec ldapreplica ./merritt-status.sh
```


### Enable replication within the primary ldap container

```bash
docker compose -f docker-compose.replication.yml exec ldap ./merritt-replication-init.sh
```

### Verify users imported into each instance (note similarities)

```bash
docker compose -f docker-compose.replication.yml exec ldap ./merritt-users.sh
```

```bash
docker compose -f docker-compose.replication.yml exec ldapreplica ./merritt-users.sh
```

### Modify users in the primary instance

```bash
docker compose -f docker-compose.replication.yml exec ldap /bin/bash
```

```bash
# ~~ in container
cat > /tmp/sample-modify.ldif << HERE
dn: uid=ned_flanders,ou=People,ou=uc3,dc=cdlib,dc=org
changetype: modify
replace: cn
cn: Edward Flanders
-
replace: givenName
givenName: Edward
-
replace: displayName
displayName: Edward Flanders

dn: uid=crusty,ou=People,ou=uc3,dc=cdlib,dc=org
changetype: add
objectClass: top
objectClass: inetOrgPerson
objectClass: merrittUser
objectClass: organizationalPerson
objectClass: person
mail: crusty@cdlib.org
sn: Clown
tzRegion: America/Los_Angeles
cn: Crusty Clown
arkId: ark:/99999/abc
givenName: Crusty
userPassword: password
uid: crusty
displayName: Crusty Clown
HERE

bin/ldapmodify -h localhost -p 1389 -D "$ROOT_USER_DN" --bindPassword $ROOT_PASSWORD \
  -f /tmp/sample-modify.ldif -v
exit
```

### Verify users imported into each instance (note that change has replicated)

```bash
docker compose -f docker-compose.replication.yml exec ldap ./merritt-users.sh
```

```bash
docker compose -f docker-compose.replication.yml exec ldapreplica ./merritt-users.sh
```

### Modify users in the replica instance to ensure 2-way replication

```bash
docker compose -f docker-compose.replication.yml exec ldapreplica /bin/bash
```

```bash
# ~~ in container
cat > /tmp/sample-modify.ldif << HERE
dn: uid=maude,ou=People,ou=uc3,dc=cdlib,dc=org
changetype: add
objectClass: top
objectClass: inetOrgPerson
objectClass: merrittUser
objectClass: organizationalPerson
objectClass: person
mail: maude@cdlib.org
sn: Flanders
tzRegion: America/Los_Angeles
cn: Maude Flanders
arkId: ark:/99999/def
givenName: Maude
userPassword: password
uid: maude
displayName: Maude Flanders
HERE

bin/ldapmodify -h localhost -p 1389 -D "$ROOT_USER_DN" --bindPassword $ROOT_PASSWORD \
  -f /tmp/sample-modify.ldif -v
exit
```

### Verify users imported into each instance (note that change has replicated)

```bash
docker compose -f docker-compose.replication.yml exec ldap ./merritt-users.sh
```

```bash
docker compose -f docker-compose.replication.yml exec ldapreplica ./merritt-users.sh
```
