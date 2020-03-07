DELIMITER $$

DROP PROCEDURE IF EXISTS  verificar_tabela_campo_valor $$
 
CREATE PROCEDURE verificar_tabela_campo_valor (
IN param_tabela  VARCHAR(250),
IN param_campo   VARCHAR(250),
IN para_valor    VARCHAR(200) ,
OUT param_qtd INT )
BEGIN
   DECLARE contador INT DEFAULT 0;    
   SET @contador = 0 ;
   SET @sql := CONCAT('SELECT COUNT(*) INTO @contador FROM ', param_tabela, ' WHERE ' , param_campo , '=' , para_valor );
   PREPARE dynamic_statement FROM @sql;
   EXECUTE dynamic_statement;
   SELECT @contador  INTO  param_qtd;
   DEALLOCATE PREPARE dynamic_statement;
  
END $$
DELIMITER ;
