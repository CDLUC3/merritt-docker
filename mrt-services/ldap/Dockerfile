ARG ECR_REGISTRY=ecr_registry_not_set

FROM ${ECR_REGISTRY}/docker-hub/openidentityplatform/opendj:5.1.1

ARG ADMIN_PASSWORD=password

ENV ROOT_PASSWORD=$ADMIN_PASSWORD
ENV BASE_DN=ou=uc3,dc=cdlib,dc=org

# docker-compose will need to use 127.0.0.1
ENV PRIMARY=ldap
ENV REPLICA=ldapreplica

WORKDIR /opt

# user is not root, so the following cannot be run
# RUN apt-get update -y && apt-get -y upgrade

# Merritt data
COPY barebones.ldif /opt/barebones.ldif
COPY barebones.export.ldif /opt/barebones.export.ldif
COPY fixup.ldif /opt/fixup.ldif
COPY 99-user.ldif /opt/99-user.ldif

COPY README.merritt.md /opt/opendj/README.merritt.md
COPY merritt*.sh /opt/opendj/

WORKDIR /opt/opendj

COPY ldap-efs-init.sh /opt/ldap-efs-init.sh

EXPOSE 1389 1636 4444 8989

USER opendj

ENTRYPOINT ["/opt/ldap-efs-init.sh"]