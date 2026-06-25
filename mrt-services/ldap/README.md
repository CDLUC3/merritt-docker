# Merritt LDAP Service

This open source service runs as a part of the [Merritt Preservation System](https://github.com/CDLUC3/mrt-doc).

## Purpose

The Merritt User Interface authenticates users sessions with LDAP.

## Details

Merritt uses [OpenDJ](https://hub.docker.com/r/openidentityplatform/opendj) for our LDAP service.

We apply a minimal configuration changes to the OpenDJ container.

## How is this Service Run?

### Docker Compose

For development testing of this component using docker compose, see [README.merritt.md](README.merritt.md).

### ECS

The Merritt System deploys this service to each of our ECS custers.  Some clusters run this service with replication, other clusters run the service as a single node.

## Configuration Files

- [99-user.ldif](99-user.ldif) contains Merritt specific LDAP schema definitions
- [barebones.ldif](barebones.ldif) contains a predictable set of users and collections.  This is loaded into a new instance if another import file is not provided.
- [simpsons.ldif](simpsons.ldif) contains test user entries for use in docker compose tests.

## Initialization Script

- [ldap-efs-init.sh](ldap-efs-init.sh) entrypoint script that handles 3 use cases
  - new instance started with no import file (barebones is loaded)
  - new instance started with an import file
  - instance is started and LDAP data directory already exists

Note: replication cannot be initialized until both a primary and replica instance have been started.  This requires a `docker exec` in order to initialize properly.

## Related Links
- [Persisting OpenDJ in Docker](https://github.com/OpenIdentityPlatform/OpenDJ/wiki/TIP:-How-to-Persist-OpenDJ-Docker-Container-Data-Between-Restarts)


## Internal Links

### Deployment and Operations at CDL

https://github.com/CDLUC3/mrt-doc-private/blob/main/uc3-mrt-ldap.md
