ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/docker-hub/openidentityplatform/opendj:4.6.3

WORKDIR /opt

# RUN apt-get update -y && apt-get -y upgrade
# Merritt data
COPY barebones.ldif /opt/barebones.ldif

COPY keystore /opt/opendj/keystore
COPY keystore.pin /opt/opendj/keystore.pin

WORKDIR /opt/opendj

RUN ./setup \
          --cli \
          --no-prompt \
          --acceptLicense \
          --backendType je \
          --baseDN ou=uc3,dc=cdlib,dc=org \
          --baseDN ou=healthcheck,dc=cdlib,dc=org \
          --ldapPort 1389 \
          --adminConnectorPort 4444 \
          --rootUserDN cn=Directory\ Manager \
          --rootUserPassword password \
          --enableStartTLS \
          --ldapsPort 1636 \
	  --useJavaKeystore /opt/opendj/keystore \
	  --keyStorePasswordFile /opt/opendj/keystore.pin \
	  --hostname ldap \
          --noPropertiesFile

# Schema data
COPY 99-user.ldif /opt/opendj/config/schema/99-user.ldif

RUN /bin/sh ./bin/import-ldif \
        --offline \
        --hostname localhost \
        --port 4444 \
	      --bindDN "cn=Directory Manager" \
        --bindPassword password \
        --backendID userRoot \
        --includeBranch "ou=uc3,dc=cdlib,dc=org" \
	      --trustAll \
        --ldifFile /opt/barebones.ldif

EXPOSE 1389 1636 4444