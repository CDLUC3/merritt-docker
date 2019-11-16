#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# docker build -t cdluc3/mrt-database .

FROM mysql:5.7

COPY init.sql /docker-entrypoint-initdb.d/start.sql

EXPOSE 3306 33060
