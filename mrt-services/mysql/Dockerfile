# docker build -t cdluc3/mrt-database .

FROM mysql:latest

COPY init.sql /docker-entrypoint-initdb.d/start.sql

EXPOSE 3306 33060
