ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/docker-hub/openidentityplatform/opendj:5.0.3

ARG ADMIN_PASSWORD=password
ENV ROOT_PASSWORD=$ADMIN_PASSWORD
ENV ROOT_USER_DN="cn=Directory Manager"
ENV BASE_DN="ou=uc3,dc=cdlib,dc=org"
ENV HOSTNAME=ldap

WORKDIR /opt

# user is not root, so the following cannot be run
# RUN apt-get update -y && apt-get -y upgrade

# Merritt data
COPY barebones.ldif /opt/barebones.ldif
COPY 99-user.ldif /opt/opendj/template/config/schema/99-user.ldif

#COPY keystore /opt/opendj/keystore
#COPY keystore.pin /opt/opendj/keystore.pin
COPY README.merritt.md /opt/opendj/README.merritt.md

WORKDIR /opt/opendj

EXPOSE 1389 1636 4444

USER opendj

ENTRYPOINT ["/opt/opendj/bin/import-ldif", "-b", "${BASE_DN}", \
  "-w", "${ROOT_PASSWORD}", "-h", "ldap", "-p", "4444", "-l", "/opt/barebones.ldif"]