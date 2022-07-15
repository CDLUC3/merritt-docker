SET sql_mode='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION';
SET FOREIGN_KEY_CHECKS=1;

GRANT ALL ON *.* to 'user'@'%';

ALTER USER 'user'@'%' IDENTIFIED WITH mysql_native_password BY 'password';

flush privileges;

DELIMITER //
DROP TRIGGER IF EXISTS insert_fulltext//
CREATE TRIGGER insert_fulltext
AFTER INSERT ON inv_dublinkernels
FOR EACH ROW
BEGIN
  IF NOT NEW.value='(:unas)' THEN
    INSERT INTO sha_dublinkernels
    VALUES (NEW.id, NEW.value);
  END IF;
END;
//
DROP TRIGGER IF EXISTS update_fulltext//
CREATE TRIGGER update_fulltext
AFTER UPDATE ON inv_dublinkernels
FOR EACH ROW
BEGIN
  IF NEW.value!='(:unas)' THEN
    UPDATE sha_dublinkernels
    SET value = NEW.value
    WHERE id = NEW.id;
  END IF;
END;
//
DROP TRIGGER IF EXISTS delete_fulltext//
CREATE TRIGGER delete_fulltext
AFTER DELETE ON inv_dublinkernels
FOR EACH ROW
BEGIN
  DELETE FROM sha_dublinkernels
  WHERE id = OLD.id;
END;
//
DELIMITER ;
