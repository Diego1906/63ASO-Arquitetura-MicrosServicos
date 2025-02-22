

BEGIN TRAN 
-- ROLLBACK 
-- COMMIT
create table #Temp(
	id INT PRIMARY KEY IDENTITY, -- Identificador único para status de conta
    descricao VARCHAR(50) NOT NULL -- Nome do status da conta
);

insert into #Temp (descricao)
values 	
	('A conta está ativa e pode ser usada normalmente.'),
	('A conta está desativada e não pode ser usada.'),
	('O usuário solicitou a exclusão da conta.'),
	('A exclusão da conta foi concluída.');


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