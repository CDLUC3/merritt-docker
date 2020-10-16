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
