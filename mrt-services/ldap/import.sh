#!/bin/sh

# Merritt data
cd /opt/opendj
/bin/sh ./bin/import-ldif \
        --hostname localhost \
        --port 4444 \
	--bindDN "cn=Directory Manager" \
        --bindPassword password \
        --backendID userRoot \
        --includeBranch "ou=uc3,dc=cdlib,dc=org" \
	--trustAll \
        --ldifFile /opt/barebones.ldif
