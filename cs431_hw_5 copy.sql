/*Name: Lorenzo Miro San Diego
Filename: cs431_hw_5.sql
Assignment: Assignment 5
*/

-- Problem 1
DROP PROCEDURE IF EXISTS test;
DELIMITER // 
CREATE PROCEDURE test()
BEGIN
	DECLARE error_var TINYINT DEFAULT FALSE;
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET error_var = true;
    
	START TRANSACTION;
    -- Delete athlete addresses where an id of 8 exists
    DELETE FROM athlete_addresses 
    WHERE athlete_id = 8;


	-- attempt commit or rollback
    IF error_var = TRUE THEN
		ROLLBACK;
	SELECT "Transaction rolled back." AS msg;
	
    ELSE COMMIT;
	SELECT "Transaction committed." AS msg;
    END IF;
    
    START TRANSACTION;
    DELETE FROM athletes
    WHERE athlete_id = 8;
    COMMIT;
    SELECT "Row removed" as msg;
    
    SELECT * FROM athlete_addresses;
    
END //
DELIMITER ;

CALL test();

-- Problem 2
DROP PROCEDURE IF EXISTS test;
DELIMITER //
CREATE PROCEDURE test()
BEGIN 
		DECLARE order_id INT;
		DECLARE error_var TINYINT DEFAULT FALSE; -- create a short int for error checking
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
		SET error_var = true;
        
	START TRANSACTION;
    
    -- add row of data into athlete_orders table (from assignment instructions)
		INSERT INTO athlete_orders
		VALUES (DEFAULT, 3, NOW(), '10.00', '0.00', NULL, 4,
 		'American Express', '378282246310005', '04/2016', 4);

 		SELECT LAST_INSERT_ID()INTO order_id;
 		INSERT INTO athlete_order_items VALUES
 		(DEFAULT, order_id, 6, '415.00', '161.85', 1);
 		INSERT INTO athlete_order_items VALUES
 		(DEFAULT, order_id, 1, '699.00', '209.70', 1);
        
	-- attempt rollback/commit
    IF error_var = FALSE THEN
		COMMIT;
	SELECT "Transaction committed." AS msg;
	
    ELSE ROLLBACK;
	SELECT "Transaction rolled back." AS msg;
    
    END IF;
    END //
    DELIMITER //
    
	SELECT * FROM athlete_order_items;
    
    CALL test();
    
	SELECT * FROM athlete_order_items;

-- Problem 3
DROP PROCEDURE IF EXISTS test;
DELIMITER //
CREATE PROCEDURE test()
BEGIN
		DECLARE error_var TINYINT DEFAULT FALSE;
    
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
		SET error_var = TRUE;
        
	START TRANSACTION;
    
    -- get athlete id 6 from tables and update the id to 3
    SELECT * FROM athletes
	WHERE athlete_id = 6 FOR SHARE;
    
    UPDATE athlete_orders SET athlete_id = 3
    WHERE athlete_id = 6;
    
    UPDATE athlete_addresses SET athlete_id = 3
    WHERE athlete_id = 6;
    
    DELETE FROM athletes 
    WHERE athlete_id = 6;
    
    -- error check transaction
    IF error_var = FALSE
		THEN COMMIT;
    SELECT "Transaction committed." as msg;
	
    ELSE ROLLBACK;
	SELECT "Transaction rolled back." as msg;
    END IF;
END //
DELIMITER ;


-- call test function
CALL test();
    
    
SELECT * FROM athlete_orders;
    
    
    
    
