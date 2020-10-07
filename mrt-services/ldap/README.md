This image will allow you to run a standalone Merritt LDAP server running in its own docker container on in your docker environment.
LDAP server is pre-populated with the "merritt-test" user and two collections.

To allow SSL request to LDAP server, use the supplied "ldap-ca.crt" CA certificate on client host.

The following instruction will check the status of the LDAP server.
    docker exec -it ldap /opt/opendj/bin/status -D "cn=Directory Manager" -w password
