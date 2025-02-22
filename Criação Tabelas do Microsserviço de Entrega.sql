USE Teste
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusEntrega]') AND type in (N'U'))
	DROP TABLE [dbo].[StatusEntrega]
GO
CREATE TABLE StatusEntrega (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para status de entrega
    nome VARCHAR(50) NOT NULL -- Nome do status de entrega
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ModalidadeEntrega]') AND type in (N'U'))
	DROP TABLE [dbo].[ModalidadeEntrega]
GO
CREATE TABLE ModalidadeEntrega (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para modalidade de entrega
    nome VARCHAR(50) NOT NULL, -- Nome da modalidade de entrega
    prazo_entrega INT NOT NULL, -- Prazo de entrega em dias
    entrega_rapida_id VARCHAR(100) UNIQUE -- Referência externa - ID correspondente da Entrega Rápida (Serviço em Nuvem)
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromocaoModalidadeEntrega]') AND type in (N'U'))
	DROP TABLE [dbo].[PromocaoModalidadeEntrega]
GO
CREATE TABLE PromocaoModalidadeEntrega (
    promocao_id INT NOT NULL, -- Referência externa (Promocao)
    modalidade_id INT NOT NULL UNIQUE, -- Identificador da modalidade de entrega associada (único)
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da associação
    PRIMARY KEY (promocao_id, modalidade_id), -- Chave primária composta
    FOREIGN KEY (modalidade_id) REFERENCES ModalidadeEntrega(id) -- Chave estrangeira para a tabela ModalidadeEntrega
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Entrega]') AND type in (N'U'))
	DROP TABLE [dbo].[Entrega]
GO
CREATE TABLE Entrega (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para entrega
    pedido_id INT NOT NULL, -- -- Referência externa (Pedido)
    status_id INT NOT NULL, -- Identificador do status da entrega
    modalidade_id INT NOT NULL, -- Identificador da modalidade de entrega
    custo_frete DECIMAL(10, 2) NOT NULL, -- Custo do frete
    desconto_frete DECIMAL(5, 2), -- Desconto em frete
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da entrega
    data_atualizacao DATETIME, -- Data de atualização da entrega
	data_prevista DATETIME, -- Data prevista para a entrega
    pedido_entrega_rapida_id VARCHAR(100), -- ID do pedido de entrega solicitado na Entrega Rápida
    endereco_entrega VARCHAR(255) NOT NULL, -- Endereço de entrega
    FOREIGN KEY (modalidade_id) REFERENCES ModalidadeEntrega(id), -- Chave estrangeira para a tabela ModalidadeEntrega
    FOREIGN KEY (status_id) REFERENCES StatusEntrega(id) -- Chave estrangeira para a tabela StatusEntrega
);
GO
