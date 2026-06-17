#!/bin/bash

if [[ "$REPLICA" != "true" ]]
then
  bin/dsreplication enable \
    --baseDN "$BASE_DN" \
    --host1 $PRIMARY --port1 4444 \
    --bindDN1 "$ROOT_USER_DN" --bindPassword1 "$ROOT_PASSWORD" \
    --replicationPort1 8989 \
    --host2 $REPLICA --port2 4444 \
    --bindDN2 "$ROOT_USER_DN" --bindPassword2 "$ROOT_PASSWORD" \
    --replicationPort2 8989 \
    --adminUID admin --adminPassword "$ROOT_PASSWORD" \
    -X -n

  bin/dsreplication initialize-all \
    --baseDN "$BASE_DN" \
    --adminUID admin --adminPassword "$ROOT_PASSWORD" \
    --hostname $PRIMARY --port 4444 \
    -X -n
else
  # for troubleshooting, try this
  # bin/dsreplication initialize \
  #   --baseDN "$BASE_DN" \
  #   --adminUID admin --adminPassword "$ROOT_PASSWORD" \
  #   -h $PRIMARY -p 4444 \
  #   --hostDestination $REPLICA --portDestination 4444 \
  #   -X -n
fi
