#!/bin/bash

setup_service() {
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
    --noPropertiesFile \
    --doNotStart

  echo "setup step complete"
}

load_ldif() {
  impfile=$1
  flags=$2

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
    $flags \
    --ldifFile $impfile

  echo "import step complete"
}

setup_service

if [ -f /opt/import/import.ldif ]
then
  load_ldif /opt/import/import.ldif "--replaceExisting"
  mv /opt/import/import.ldif /opt/import/import.ldif.loaded
else
  load_ldif /opt/barebones.ldif
fi

/opt/opendj/run.sh