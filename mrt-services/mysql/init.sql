DROP TABLE IF EXISTS test;
CREATE TABLE test(
id INT
);

CREATE USER user@'%';
GRANT ALL ON *.* to 'user'@'%';

flush privileges;
