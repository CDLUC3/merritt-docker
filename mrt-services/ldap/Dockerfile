# https://github.com/ghchinoy/forgerock-docker
FROM public.ecr.aws/docker/library/openjdk:11-jdk-bookworm

WORKDIR /opt

RUN apt-get update -y && apt-get -y upgrade
RUN apt-get install -y wget unzip

RUN curl --silent -LO https://github.com/OpenIdentityPlatform/OpenDJ/releases/download/4.4.5/opendj-4.4.5.zip && unzip -q opendj-4.4.5.zip && rm -r opendj-4.4.5.zip

# Merritt data
COPY barebones.ldif /opt/barebones.ldif

# Entrypoint script
COPY start_import.sh /opt/start_import.sh
RUN chmod +x /opt/start_import.sh

# Import script
COPY import.sh /opt/opendj/import.sh
RUN chmod +x /opt/opendj/import.sh

# Self signed cert
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

EXPOSE 1389 1636 4444

ENTRYPOINT ["/opt/start_import.sh"]
