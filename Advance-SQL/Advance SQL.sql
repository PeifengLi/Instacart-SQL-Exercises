USE Instacart;

ALTER TABLE Products ADD price INT;

ALTER TABLE Order_products ADD price INT;

-- Using SQL Cursor fill "price" column in "products" table with a random number between 1 to 1000

DELIMITER //

CREATE PROCEDURE add_product_prices()
BEGIN
DECLARE seq INT;
DECLARE done INT DEFAULT TRUE;
DECLARE cursor_results CURSOR FOR SELECT product_id FROM Products FOR UPDATE;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = FALSE;
OPEN cursor_results;
	FETCH cursor_results INTO seq;
    WHILE done
		DO BEGIN
			UPDATE Products SET price=FLOOR(1+rand()*1000) WHERE product_id=seq;
            FETCH cursor_results INTO seq;
		END;
	END WHILE;
CLOSE cursor_results;
END//

CALL add_product_prices();

SELECT MAX(price) from Products;

-- fill "price" column in "order_products" table with the corresponding price in "products" table

DELIMITER //

CREATE PROCEDURE add_orderproduct_prices()
BEGIN
DECLARE seq INT;
DECLARE done INT DEFAULT TRUE;
DECLARE cursor_results CURSOR FOR SELECT product_id FROM Order_products FOR UPDATE;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = FALSE;
OPEN cursor_results;
	FETCH cursor_results INTO seq;
    WHILE done
		DO BEGIN
			UPDATE Order_products SET price = (SELECT price FROM Products WHERE product_id=seq) WHERE product_id=seq;
            FETCH cursor_results INTO seq;
		END;
	END WHILE;
CLOSE cursor_results;
END//

CALL add_orderproduct_prices();

SELECT COUNT(*) FROM Order_products where price is NULL;

SELECT distinct product_id, price from Products order by product_id;
SELECT distinct product_id, price from Order_products order by product_id;

-- BEGIN 
BEGIN 
START TRANSACTION;
	INSERT INTO Aisles VALUES(300, 'tt', 3);
    SAVEPOINT cp1;
    DELETE FROM Aisles WHERE aisle_id = 300;
    ROLLBACK TO SAVEPOINT cp1;
COMMIT;
END;

-- BEGIN-END
BEGIN 
	SELECT * FROM Aisles;
END;

-- IF-ELSE
BEGIN 
	IF(SELECT COUNT(*) FROM Aisles) > 100
    THEN SELECT '>100';
    ELSE SELECT '<100';
    END IF;
END;

-- WHILE-BREAK-CONTINUE
BEGIN
labela: WHILE (SELECT price from Products where product_id = 1)
	DO BEGIN
		UPDATE Products SET price = price * 2 WHERE product_id = 1;
        IF (SELECT price FROM Products WHERE product_id = 1) > 4000
        THEN LEAVE labela;
        ELSE ITERATE labela;
        END IF;
	END;
    END WHILE;
END;

-- GOTO /MySQL NOT SUPPORT THIS FUNCTION
DECLARE @num INT;
BEGIN
	SET @num = (SELECT COUNT(*) FROM Aisles)
    IF @num > 100 GOTO Branch_one
    IF @num < 100 GOTO Branch_two
END

Branch_one: SELECT 'Branch_one'
Branch_two: SELECT 'Branch_two'
TheEnd：SELECT 'The_end'

-- RETURN
CREATE FUNCTION 'return' RETURNS INT(11)
BEGIN
DECLARE num INT;
SET num = 100;
IF(SELECT COUNT(*) FROM Aisles) > num THEN RETURN 1;
ELSE RETURN 0;
END IF;
END;

-- CASE
CREATE PROCEDURE case_sample()
BEGIN
SELECT product_id, product_name, price,
	CASE WHEN price = 0 THEN 'Not for resale'
    WHEN price < 50 THEN 'Under 50'
    WHEN price >= 50 AND price < 500 THEN '50 to 500'
    WHEN price >= 500 AND price < 1000 THEN '500 to 1000'
    ELSE 'Over 1000'
    END
    FROM Products;
END;
END;

-- WAIT FOR
BEGIN
	SELECT SLEEP(5);
	SELECT * FROM Products WHERE product_id = 1;
END;

-- TRY...CATCH
BEGIN 
DECLARE EXIT HANDLER FOR SQLEXEPTION
	BEGIN 
		SELECT 'No column product in Products';
	END;
    SELECT product_name FROM Products;
    SELECT * FROM Aisles;
END;

-- THROW
BEGIN
DECLARE EXIT HANDLER FOR SQLEXEPTION
	BEGIN
		SIGNAL SQLSTATE VALUE '99999'
        SET MESSAGE_TEST = 'An error occurred'
	END;
    SELECT product_name FROM Products
    SELECT * FROM Aisles;
END;

-- DDL TRIGERS
-- CREATE
CREATE TRIGGER DDL_TRIGGER ON Instacart
FOR DROP_TABLE AS 
PRINT 'YOU CAN NOT DROP TABLE'
ROLLBACK;

-- DROP
DROP TRIGGER DDL_TRIGGER ON Instacart;

-- ALTER
ALTER TRIGGER DDL_TRIGGER ON Instacart
FOR ALTER_TABLE AS 
PRINT 'YOU CAN NOT ALTER TABLE'
ROLLBACK;

-- EABLE
ENABLE TRIGGER DDL_TRIGGER ON Instacart;

-- DISABLE
DISABLE TRIGGER DDL_TRIGGER ON Instacart;


-- DML TRIGGERS
-- CREATE
CREATE TRIGGER DML_TRIGGER BEFORE INSERT ON Aisles
FOR EACH ROW
SIGNAL SQLSTATE VALUE '99999'
MESSAGE_TEXT = 'An error occurred';

-- DROP
DROP TRIGGER DML_TRIGGER;

-- Alter(MySQL does not support alter, enable and disable just write down how it should be like)
ALTER TRIGGER DML_TRIGGER BEFORE INSERT ON Aisles DML_trigger
FOR EACH ROW
	SIGNAL SQLSTATE VALUE '99999'
	SET MESSAGE_TEXT = 'Not allowed to insert data';

-- Enable

ENABLE TRIGGER DML_TRIGGER;

ENABLE TRIGGER DML_TRIGGER ON Aisles -- sql server syntax

-- Disable
DISABLE TRIGGER DML_TRIGGER;

DISABLE TRIGGER DML_TRIGGER ON Aisles -- sql server syntax


