USE FiapStore_PagamentoDataBase
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MetodoPagamento]') AND type in (N'U'))
	DROP TABLE [dbo].[MetodoPagamento]
GO
CREATE TABLE MetodoPagamento (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador �nico para m�todo de pagamento
    nome VARCHAR(50) NOT NULL, -- Nome do m�todo de pagamento
    paguei_id VARCHAR(100) NOT NULL UNIQUE -- ID correspondente na Paguei. Refer�ncia externa (Servi�o em Nuvem) 
);


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusPagamento]') AND type in (N'U'))
	DROP TABLE [dbo].[StatusPagamento]
GO
CREATE TABLE StatusPagamento (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador �nico para status de pagamento
    nome VARCHAR(50) NOT NULL -- Nome do status de pagamento
);


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pagamento]') AND type in (N'U'))
	DROP TABLE [dbo].[Pagamento]
GO
CREATE TABLE Pagamento (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador �nico para pagamento
    pedido_id INT NOT NULL, -- Identificador do pedido associado. Refer�ncia externa (Pedido)
    status_id INT NOT NULL, -- Identificador do status do pagamento
    metodo_pagamento_id INT NOT NULL, -- Identificador do m�todo de pagamento
    desconto_pagamento DECIMAL(5, 2), -- Desconto no pagamento
    pedido_paguei_id VARCHAR(100), -- ID do pedido de pagamento gerado na Paguei para o m�todo de pagamento correspondente. Refer�ncia externa (Servi�o em Nuvem) 
    preco_total DECIMAL(10, 2) NOT NULL, -- Pre�o total do pagamento
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o do pagamento
    data_atualizacao DATETIME, -- Data de atualiza��o do pagamento
    FOREIGN KEY (metodo_pagamento_id) REFERENCES MetodoPagamento(id), -- Chave estrangeira para a tabela MetodoPagamento
    FOREIGN KEY (status_id) REFERENCES StatusPagamento(id) -- Chave estrangeira para a tabela StatusPagamento
);


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromocaoMetodoPagamento]') AND type in (N'U'))
	DROP TABLE [dbo].[PromocaoMetodoPagamento]
GO
CREATE TABLE PromocaoMetodoPagamento (
    promocao_id INT NOT NULL, -- Identificador da promo��o associada. Refer�ncia externa (Promo��o)
    metodo_pagamento_id INT NOT NULL UNIQUE, -- Identificador do m�todo de pagamento associado (�nico)
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o da associa��o
    PRIMARY KEY (promocao_id, metodo_pagamento_id), -- Chave prim�ria composta
    FOREIGN KEY (metodo_pagamento_id) REFERENCES MetodoPagamento(id) -- Chave estrangeira para a tabela MetodoPagamento
);
GO