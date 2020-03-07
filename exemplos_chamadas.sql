
SET @qtd = 0 ; 
CALL  verificar_tabela_campo_valor("nome_tbl", "fk_tbl", "168" , @qtd  ) ;  
SELECT @qtd as quantidade; 


SET @list :=  JSON_ARRAY(162 , 168 , 200 , 400 ) ;
CALL verificar_referencias_tabela_lista_chave("nome_tbl" ,  @list ) ;
