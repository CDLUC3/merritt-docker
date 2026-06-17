#!/bin/bash

# 127.0.0.1 is needed for docker-compose, ignoring this logic for now.

if [[ "$REPLICA" == "true" ]]
then
  PRIMARY=ldap
  SECONDARY=127.0.0.1
else
  PRIMARY=127.0.0.1
  SECONDARY=ldapreplica
fi

# bin/dsreplication disable \
#   --disableAll \
#   --adminUID admin --adminPassword "$ROOT_PASSWORD" \
#   -X -n

bin/dsreplication enable \
  --baseDN "$BASE_DN" \
  --host1 ldap --port1 4444 \
  --bindDN1 "$ROOT_USER_DN" --bindPassword1 "$ROOT_PASSWORD" \
  --replicationPort1 8989 \
  --host2 ldapreplica --port2 4444 \
  --bindDN2 "$ROOT_USER_DN" --bindPassword2 "$ROOT_PASSWORD" \
  --replicationPort2 8989 \
  --adminUID admin --adminPassword "$ROOT_PASSWORD" \
  -X -n

if [[ "$REPLICA" != "true" ]]
then
  bin/dsreplication initialize-all \
    --baseDN "$BASE_DN" \
    --adminUID admin --adminPassword "$ROOT_PASSWORD" \
    --hostname ldap --port 4444 \
    -X -n
else
  bin/dsreplication initialize \
    --baseDN "$BASE_DN" \
    --adminUID admin --adminPassword "$ROOT_PASSWORD" \
    -h ldap -p 4444 \
    --hostDestination ldapreplica --portDestination 4444 \
    -X -n
fi
