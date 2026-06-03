#!/bin/bash

if [[ "$REPLICA" == "true" ]]
then
  PRIMARY=ldap
  SECONDARY=localhost
else
  PRIMARY=localhost
  SECONDARY=ldapreplica
fi

bin/dsreplication enable \
  --baseDN "$BASE_DN" \
  --host1 $PRIMARY --port1 4444 \
  --bindDN1 "cn=Directory Manager" --bindPassword1 "$ROOT_PASSWORD" \
  --replicationPort1 8989 \
  --host2 $SECONDARY --port2 4444 \
  --bindDN2 "cn=Directory Manager" --bindPassword2 "$ROOT_PASSWORD" \
  --replicationPort2 8989 \
  --adminUID admin --adminPassword "$ROOT_PASSWORD" \
  --baseDN "$BASE_DN" -X -n

if [[ "$REPLICA" != "true" ]]
then
  bin/dsreplication initialize-all \
    --baseDN "$BASE_DN" \
    --adminUID admin --adminPassword "$ROOT_PASSWORD" \
    --hostname $PRIMARY --port 4444 \
    -X -n
fi