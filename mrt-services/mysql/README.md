## Connect as root
docker run --rm -it --network mrt-services_merrittnet mysql mysql -h db-container -D db-name -u root -p

## Connect as user
docker run --rm -it --network mrt-services_merrittnet mysql mysql -h db-container -D db-name -u user -p

## MySql dump (-d generates the schema only)
docker run --rm -it --network mrt-services_merrittnet mysql mysqldump -h db-container -u root -p -d --skip-lock-tables db-name
