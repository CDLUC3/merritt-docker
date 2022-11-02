#*********************************************************************
#   Copyright 2019 Regents of the University of California
#   All rights reserved
#*********************************************************************
# docker build -t ${ECR_REGISTRY}/mrt-it-database:dev .
# aws ecr create-repository --repository-name mrt-it-database
# docker push ${ECR_REGISTRY}/mrt-it-database:dev

FROM mysql:8

ARG LOAD_SQL=/dev/null

RUN echo "USE mysql;" > /docker-entrypoint-initdb.d/timezones.sql &&  mysql_tzinfo_to_sql /usr/share/zoneinfo >> /docker-entrypoint-initdb.d/timezones.sql

# RUN apt-get update -y
# RUN yum -y update

COPY *.sql schema.prd.norm /tmp/

RUN cat /tmp/schema.addition.pre.sql \
        /tmp/schema.prd.norm \
        $LOAD_SQL \
        /tmp/schema.addition.post.sql > /docker-entrypoint-initdb.d/start.sql

# https://serverfault.com/questions/683605/docker-container-time-timezone-will-not-reflect-changes
ENV TZ=America/Los_Angeles
# RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 3306 33060

CMD ["mysqld", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]