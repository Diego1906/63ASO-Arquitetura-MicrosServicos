

BEGIN TRAN 
-- ROLLBACK 
-- COMMIT
create table #Temp(
	id INT PRIMARY KEY IDENTITY, -- Identificador �nico para status de conta
    descricao VARCHAR(50) NOT NULL -- Nome do status da conta
);

insert into #Temp (descricao)
values 	
	('A conta est� ativa e pode ser usada normalmente.'),
	('A conta est� desativada e n�o pode ser usada.'),
	('O usu�rio solicitou a exclus�o da conta.'),
	('A exclus�o da conta foi conclu�da.');


UPDATE S
SET
    S.descricao = T.descricao
FROM
    StatusConta AS S
JOIN #Temp AS T 
		ON S.id = T.id;



select * from StatusConta

select * from #Temp


/*

If(OBJECT_ID('tempdb..#Temp') Is Not Null)
Begin
    Drop Table #Temp
EnD
*/