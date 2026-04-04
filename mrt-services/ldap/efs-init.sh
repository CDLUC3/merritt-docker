#!/bin/bash

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
  --noPropertiesFile

echo "setup step complete"

/opt/opendj/bin/stop-ds --quiet

# Schema data
cp /opt/99-user.ldif /opt/opendj/config/schema/99-user.ldif

./bin/import-ldif \
  --offline \
  --hostname localhost \
  --port 4444 \
  --bindDN "cn=Directory Manager" \
  --bindPassword $ROOT_PASSWORD \
  --backendID userRoot \
  --includeBranch "ou=uc3,dc=cdlib,dc=org" \
  --trustAll \
  --ldifFile /opt/import/import.ldif

echo "import step complete"
