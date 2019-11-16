#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
#   docker build -t cdluc3/mrt-conf-mock .

FROM maven:3-jdk-8 as build
WORKDIR /tmp

ADD . /tmp

RUN mvn install && mvn clean
