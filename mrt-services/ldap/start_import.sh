#!/bin/sh

# start openDJ (detached) 
/opt/opendj/bin/start-ds

# import Merritt data
/bin/sh /opt/opendj/import.sh

# Do not exit, docker container will stop
/usr/bin/tail -f /dev/null
