This image will allow you to run a standalone Merritt inventory database running in its own docker container on in your docker environment.

The following instructions will allow you to connect to that instance.

## Connect as root
docker run --rm -it --network merritt_merrittnet mysql mysql -h db-container -D db-name -u root -p

## Connect as user
docker run --rm -it --network merritt_merrittnet mysql mysql -h db-container -D db-name -u user -p

## MySql dump (-d generates the schema only)
docker run --rm -it --network merritt_merrittnet mysql mysqldump -h db-container -u root -p -d --skip-lock-tables db-name
