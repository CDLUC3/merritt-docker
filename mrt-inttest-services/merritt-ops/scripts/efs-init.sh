#! /bin/bash

for dir in /ingest/queue /uploads /assemblies /zk-snapshots /ldap /ldap/import /ldap/data /ldapreplica /ldapreplica/data
do
  mkdir -p /merritt-filesys/$dir
  chmod 775 /merritt-filesys/$dir
done

for dir in /ldap /ldap/import /ldapreplica
do
  chown opendj:opendj /merritt-filesys/$dir
done
