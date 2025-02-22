USE Teste
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusPedido]') AND type in (N'U'))
	DROP TABLE [dbo].[StatusPedido]
GO
CREATE TABLE [dbo].[StatusPedido](
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	nome VARCHAR(50) NOT NULL
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Pedido]') AND type in (N'U'))
	DROP TABLE [dbo].Pedido
GO
CREATE TABLE [dbo].[Pedido] (
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	conta_id INT NOT NULL,  -- Referência externa (Cliente)
	data_criacao DATETIME DEFAULT GETDATE(),
	data_atualizacao DATETIME NULL,
	status_pedido_id INT NOT NULL,
	FOREIGN KEY (status_pedido_id) REFERENCES StatusPedido(id)
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PedidoItem]') AND type in (N'U'))
	DROP TABLE [dbo].[PedidoItem]
GO
CREATE TABLE [dbo].[PedidoItem] (
	id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	pedido_id INT NOT NULL,
	produto_id INT NOT NULL,  -- Referência externa (Produto)
	quantidade INT NOT NULL CHECK (quantidade > 0),
	preco_unitario DECIMAL(10,2) NOT NULL,
	desconto DECIMAL(10,2) DEFAULT 0,
	data_criacao DATETIME DEFAULT GETDATE(),
	FOREIGN KEY (pedido_id) REFERENCES Pedido(id)
);
GO
