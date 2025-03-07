This image will allow you to run a standalone Merritt LDAP server running in its own docker container.
The OpenDJ LDAP server is prepopulated with the barebones.ldif input data file.  This file includes two users 
(merritt-test and anonymous) and two collections.  Passwords for users are:

`merritt-test: password`
`Admin User: password`

To allow SSL request to LDAP server, use the supplied "ldap-ca.crt" CA certificate on client host.

The following instruction will check the status of the LDAP server.
```
    docker exec -it ldap /opt/opendj/bin/status -D "cn=Directory Manager" -w password
```

## Migration

```
ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/docker-hub/openidentityplatform/opendj:4.6.3

WORKDIR /opt/opendj

ENV ROOT_PASSWORD password

# RUN apt-get update -y && apt-get -y upgrade
# Merritt data
COPY barebones.ldif /opt/barebones.ldif
COPY 99-user.ldif /opt/opendj/config/schema/99-user.ldif

EXPOSE 1389 1636 4444
```