#!/bin/bash
bin/ldapsearch -h localhost -p 1389 -b "" "(objectclass=merrittClass)" | egrep "(dn|description):"
