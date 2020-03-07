DELIMITER $$
DROP PROCEDURE IF EXISTS  verificar_referencias_tabela_lista_chave $$

CREATE PROCEDURE  verificar_referencias_tabela_lista_chave(
IN param_tabela  VARCHAR(250),
IN param_lista_valor TEXT )
NOT DETERMINISTIC
MODIFIES SQL DATA
BEGIN
	DECLARE tabela VARCHAR(100);
    DECLARE fk VARCHAR(100);
    DECLARE qtd INT;
    DECLARE i INT UNSIGNED DEFAULT 0;
    DECLARE v_count INT UNSIGNED DEFAULT JSON_LENGTH(param_lista_valor);
    DECLARE v_current_item BLOB DEFAULT NULL;
    DECLARE exit_loop BOOLEAN;  
    DECLARE tabela_fk_cursor CURSOR FOR SELECT TABLE_NAME, COLUMN_NAME
	  FROM
       INFORMATION_SCHEMA.KEY_COLUMN_USAGE
      WHERE
	-- REFERENCED_TABLE_SCHEMA = 'db_name' AND 
        REFERENCED_TABLE_NAME = param_tabela ;
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET exit_loop = TRUE;
   CREATE TEMPORARY TABLE IF NOT EXISTS tabela_fk_qtd( id VARCHAR(250) , tabela  VARCHAR(200), fk  VARCHAR(200) ,  qtd  INT  );
  
   SET exit_loop = FALSE; 
   OPEN tabela_fk_cursor;
   -- start looping
   START TRANSACTION;
   tabela_fk_loop: LOOP
	    FETCH  tabela_fk_cursor INTO tabela, fk;
	     IF exit_loop THEN
	         CLOSE tabela_fk_cursor;
	         LEAVE tabela_fk_loop;
	     END IF;
	    
	    -- loop from 0 to the last item
	    WHILE i < v_count DO        
	        SET v_current_item := JSON_EXTRACT(param_lista_valor, CONCAT('$[', i, ']'));
	       	CALL verificar_tabela_campo_valor(tabela, fk, v_current_item, qtd);
	        INSERT INTO tabela_fk_qtd (id, tabela , fk , qtd) SELECT v_current_item, tabela , fk , qtd; 
	        SET i := i + 1;
       END WHILE;
       SET i:= 0; -- next item loop  
       
   END LOOP tabela_fk_loop;
   COMMIT; 
   SELECT * FROM tabela_fk_qtd  ORDER BY id ; 
   DROP TEMPORARY TABLE IF EXISTS  tabela_fk_qtd; 
   SET exit_loop = FALSE; 
   
 END $$
DELIMITER ;
