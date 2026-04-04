#!/bin/bash

source /opt/ecs-helpers.sh

export label="Run LDAP Load"
export statfile="/tmp/ldap-load.txt"

task_init

./setup \
  --cli \
  --no-prompt \
  --acceptLicense \
  --backendType je \
  --baseDN ou=uc3,dc=cdlib,dc=org \
  --baseDN ou=healthcheck,dc=cdlib,dc=org \
  --ldapPort 1389 \
  --adminConnectorPort 4444 \
  --rootUserDN 'cn=Directory Manager' \
  --rootUserPassword "$ROOT_PASSWORD" \
  --enableStartTLS \
  --ldapsPort 1636 \
  --useJavaKeystore /opt/opendj/keystore \
  --keyStorePasswordFile /opt/opendj/keystore.pin \
  --hostname ldap \
  --noPropertiesFile || task_fail

echo "setup step complete"

# Schema data
cp /opt/99-user.ldif /opt/opendj/config/schema/99-user.ldif || task_fail

./bin/import-ldif \
  --offline \
  --hostname localhost \
  --port 4444 \
  --bindDN "cn=Directory Manager" \
  --bindPassword $ROOT_PASSWORD \
  --backendID userRoot \
  --includeBranch "ou=uc3,dc=cdlib,dc=org" \
  --trustAll \
  --ldifFile /opt/import/import.ldif || task_fail

echo "import step complete"

task_complete