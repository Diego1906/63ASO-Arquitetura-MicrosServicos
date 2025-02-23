USE FiapStore_PedidoDataBase
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusPedido]') AND type in (N'U'))
	DROP TABLE [dbo].[StatusPedido]
GO
CREATE TABLE [dbo].[StatusPedido](
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para status de pedido
	nome VARCHAR(50) NOT NULL  -- Nome do status de pedido
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedido]') AND type in (N'U'))
	DROP TABLE [dbo].[Pedido]
GO
CREATE TABLE [dbo].[Pedido] (
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para pedido
	conta_id INT NOT NULL,  -- Identificador da conta associada. Referência externa (Conta)
	data_criacao DATETIME DEFAULT GETDATE(),  -- Data de criação do pedido
	data_atualizacao DATETIME NULL, -- Data de atualização do pedido
	status_pedido_id INT NOT NULL,-- Identificador do status do pedido
	FOREIGN KEY (status_pedido_id) REFERENCES StatusPedido(id) -- Chave estrangeira para a tabela StatusPedido
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PedidoItem]') AND type in (N'U'))
	DROP TABLE [dbo].[PedidoItem]
GO
CREATE TABLE [dbo].[PedidoItem] (
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para item do pedido
	pedido_id INT NOT NULL, -- Identificador do pedido associado
	produto_id INT NOT NULL,  -- Identificador do produto associado. Referência externa (Produto)
	quantidade INT NOT NULL CHECK (quantidade > 0), -- Quantidade do produto no pedido
	preco_individual DECIMAL(10, 2) NOT NULL, -- Preço individual do item no momento da criação do pedido
	desconto_produto DECIMAL(5, 2), -- Desconto no produto
	data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação do item do pedido
    data_atualizacao DATETIME, -- Data de atualização do item do pedido,
	UNIQUE (pedido_id, produto_id), -- Garantir unicidade de produto no pedido
	FOREIGN KEY (pedido_id) REFERENCES Pedido(id) -- Chave estrangeira para a tabela Pedido
);
GO
