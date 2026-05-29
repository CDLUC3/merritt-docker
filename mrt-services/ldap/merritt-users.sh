#!/bin/bash
bin/ldapsearch -h localhost -p 1389 -b "" "(objectclass=inetOrgPerson)" | egrep "(dn|displayName):"
