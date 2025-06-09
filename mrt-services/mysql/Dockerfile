#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************

FROM public.ecr.aws/ubuntu/mysql
RUN echo "USE mysql;" > /docker-entrypoint-initdb.d/timezones.sql &&  mysql_tzinfo_to_sql /usr/share/zoneinfo >> /docker-entrypoint-initdb.d/timezones.sql

RUN apt-get update -y
# RUN yum -y update

COPY init.sql /docker-entrypoint-initdb.d/start.sql
COPY custom.cnf /etc/mysql/conf.d/

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 3306 33060

CMD ["mysqld", "--sql_mode=", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]