DELIMITER $$
 DROP PROCEDURE IF EXISTS  verificar_referencias_tabela_chave $$

CREATE PROCEDURE  verificar_referencias_tabela_chave(
IN param_tabela  VARCHAR(250),
IN param_valor   VARCHAR(250) )
BEGIN
	DECLARE tabela VARCHAR(100);
    DECLARE fk VARCHAR(100);
    DECLARE qtd INT;
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
	  
	    CALL verificar_tabela_campo_valor(tabela, fk, param_valor, qtd);
	    INSERT INTO tabela_fk_qtd (id, tabela , fk , qtd) SELECT param_valor, tabela , fk , qtd; 
	   
   END LOOP tabela_fk_loop;
   COMMIT; 
   SELECT * FROM tabela_fk_qtd ; 
   DROP TEMPORARY TABLE IF EXISTS  tabela_fk_qtd; 
   SET exit_loop = FALSE; 
   
 END $$
DELIMITER ;
