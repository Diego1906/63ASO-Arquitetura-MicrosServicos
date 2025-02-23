
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusConta]') AND type in (N'U'))
	DROP TABLE [dbo].[StatusConta]
GO
-- Tabela auxiliar para status de Conta
CREATE TABLE StatusConta (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para status de conta
    nome VARCHAR(50) NOT NULL -- Nome do status da conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TipoPromocao]') AND type in (N'U'))
	DROP TABLE [dbo].[TipoPromocao]
GO
-- Tabela auxiliar para tipos de promo��o
CREATE TABLE TipoPromocao (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para tipo de promo��o
    nome VARCHAR(50) NOT NULL -- Nome do tipo de promo��o
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Perfil]') AND type in (N'U'))
	DROP TABLE [dbo].[Perfil]
GO
-- Tabela para perfis de usu�rio
CREATE TABLE Perfil (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para perfil de usu�rio
    nome VARCHAR(50) NOT NULL -- Nome do perfil de usu�rio
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND type in (N'U'))
	DROP TABLE [dbo].[Cliente]
GO
-- Tabelas para registros de clientes
CREATE TABLE Cliente (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para cliente
    nome VARCHAR(100) NOT NULL, -- Nome do cliente
    email VARCHAR(255) NOT NULL UNIQUE, -- Email do cliente (�nico)
    telefone VARCHAR(20), -- Telefone do cliente
    data_atualizacao DATETIME -- Data de atualiza��o do registro do cliente
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Conta]') AND type in (N'U'))
	DROP TABLE [dbo].[Conta]
GO
-- Tabela de Conta
CREATE TABLE Conta (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para conta
    cliente_id INT NOT NULL UNIQUE, -- Identificador do cliente associado (�nico)
    senha_sha256 VARCHAR(64) NOT NULL, -- Hash SHA-256 da senha do cliente
    salt VARCHAR(32) NOT NULL, -- Salt utilizado para a hash da senha
    mfa VARCHAR(50), -- M�todo de autentica��o multifator (MFA) habilitado
    status_id INT NOT NULL, -- Identificador do status da conta
    perfil_id INT NOT NULL DEFAULT 1, -- Identificador do perfil da conta (padr�o: Cliente)
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o da conta
    data_atualizacao DATETIME, -- Data de atualiza��o da conta
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id), -- Chave estrangeira para a tabela Cliente
    FOREIGN KEY (status_id) REFERENCES StatusConta(id), -- Chave estrangeira para a tabela StatusConta
    FOREIGN KEY (perfil_id) REFERENCES Perfil(id) -- Chave estrangeira para a tabela Perfil
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Endereco]') AND type in (N'U'))
	DROP TABLE [dbo].[Endereco]
GO
-- Tabela de Endere�os
CREATE TABLE Endereco (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para endere�o
    conta_id INT NOT NULL, -- Identificador da conta associada
    nome VARCHAR(100) NOT NULL, -- Nome do endere�o (ex.: Casa, Trabalho)
    endereco VARCHAR(255) NOT NULL, -- Endere�o completo
    cidade VARCHAR(100) NOT NULL, -- Cidade
    estado VARCHAR(50) NOT NULL, -- Estado
    cep VARCHAR(20) NOT NULL, -- C�digo postal
    pais VARCHAR(50) NOT NULL, -- Pa�s
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o do endere�o
    data_atualizacao DATETIME, -- Data de atualiza��o do endere�o
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NivelFidelidade]') AND type in (N'U'))
	DROP TABLE [dbo].[NivelFidelidade]
GO
-- Tabelas para o m�dulo Fidelidade
CREATE TABLE NivelFidelidade (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para n�vel de fidelidade
    nome VARCHAR(50) NOT NULL, -- Nome do n�vel de fidelidade
    desconto_frete DECIMAL(5, 2) NOT NULL, -- Desconto em frete
    desconto_produto DECIMAL(5, 2) NOT NULL -- Desconto em produtos
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fidelidade]') AND type in (N'U'))
	DROP TABLE [dbo].[Fidelidade]
GO
CREATE TABLE Fidelidade (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para fidelidade
    conta_id INT NOT NULL UNIQUE, -- Identificador da conta associada (�nico)
    progresso DECIMAL(5,2) NOT NULL, -- Progresso de fidelidade
    nivel_id INT NOT NULL, -- Identificador do n�vel de fidelidade
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o da fidelidade
    data_atualizacao DATETIME, -- Data de atualiza��o da fidelidade
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (nivel_id) REFERENCES NivelFidelidade(id) -- Chave estrangeira para a tabela NivelFidelidade
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carrinho]') AND type in (N'U'))
	DROP TABLE [dbo].[Carrinho]
GO
-- Tabelas para o m�dulo Carrinho
CREATE TABLE Carrinho (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para carrinho
    conta_id INT NOT NULL UNIQUE, -- Identificador da conta associada (�nico)
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categoria]') AND type in (N'U'))
	DROP TABLE [dbo].[Categoria]
GO
-- Tabelas para o m�dulo Cat�logo de Produtos
CREATE TABLE Categoria (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para categoria
    nome VARCHAR(100) NOT NULL, -- Nome da categoria
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o da categoria
    data_atualizacao DATETIME -- Data de atualiza��o da categoria
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produto]') AND type in (N'U'))
	DROP TABLE [dbo].[Produto]
GO
CREATE TABLE Produto (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para produto
    sku VARCHAR(50) NOT NULL UNIQUE, -- SKU do produto (�nico)
    ean VARCHAR(50) NOT NULL UNIQUE, -- EAN do produto (�nico)
    nome VARCHAR(100) NOT NULL, -- Nome do produto
    descricao TEXT, -- Descri��o do produto
    categoria_id INT, -- Identificador da categoria associada
    ativo BIT NOT NULL, -- Indicador se o produto est� ativo
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o do produto
    data_atualizacao DATETIME, -- Data de atualiza��o do produto
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id) -- Chave estrangeira para a tabela Categoria
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CarrinhoItem]') AND type in (N'U'))
	DROP TABLE [dbo].[CarrinhoItem]
GO
CREATE TABLE CarrinhoItem (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para item do carrinho
    carrinho_id INT NOT NULL, -- Identificador do carrinho associado
    produto_id INT NOT NULL, -- Identificador do produto associado
    quantidade INT NOT NULL CHECK (quantidade > 0), -- Quantidade do produto no carrinho
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o do item do carrinho
    data_atualizacao DATETIME, -- Data de atualiza��o do item do carrinho
    UNIQUE (carrinho_id, produto_id), -- Garantir unicidade de produto no carrinho
    FOREIGN KEY (carrinho_id) REFERENCES Carrinho(id), -- Chave estrangeira para a tabela Carrinho
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItensSalvos]') AND type in (N'U'))
	DROP TABLE [dbo].[ItensSalvos]
GO
CREATE TABLE ItensSalvos (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para item salvo
    conta_id INT NOT NULL, -- Identificador da conta associada
    produto_id INT NOT NULL, -- Identificador do produto associado
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o do item salvo
    UNIQUE (conta_id, produto_id), -- Garantir unicidade de produto salvo por conta
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Recomendacao]') AND type in (N'U'))
	DROP TABLE [dbo].[Recomendacao]
GO
-- Tabelas para o m�dulo Recomenda��o
CREATE TABLE Recomendacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para recomenda��o
    conta_id INT NOT NULL, -- Identificador da conta associada
    produto_id INT NOT NULL, -- Identificador do produto associado
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o da recomenda��o
    UNIQUE (conta_id, produto_id), -- Garantir unicidade de produto recomendado por conta
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Busca]') AND type in (N'U'))
	DROP TABLE [dbo].[Busca]
GO
-- Tabelas para o m�dulo Busca
CREATE TABLE Busca (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para busca
    termo_busca VARCHAR(255) NOT NULL, -- Termo buscado
    conta_id INT NOT NULL, -- Identificador da conta associada
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o da busca
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdutoMedia]') AND type in (N'U'))
	DROP TABLE [dbo].[ProdutoMedia]
GO
-- Tabela para URLs de imagens e v�deos do produto
CREATE TABLE ProdutoMedia (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para m�dia do produto
    produto_id INT NOT NULL, -- Identificador do produto associado
    ordem INT NOT NULL, -- Ordem da m�dia do produto, para exibi��o
    url VARCHAR(255) NOT NULL, -- URL da m�dia
    tipo VARCHAR(50) NOT NULL, -- Tipo de m�dia: 'Imagem' ou 'V�deo'
    principal BIT NOT NULL, -- Indicador se a m�dia � principal, para exibi��o em lista de produtos
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o da m�dia
    data_atualizacao DATETIME, -- Data de atualiza��o da m�dia
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carrousel]') AND type in (N'U'))
	DROP TABLE [dbo].[Carrousel]
GO
CREATE TABLE Carrousel (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para carrossel
    ordem INT NOT NULL, -- Ordem do carrossel
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (�nico)
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o do carrossel
    data_atualizacao DATETIME, -- Data de atualiza��o do carrossel
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Estoque]') AND type in (N'U'))
	DROP TABLE [dbo].[Estoque]
GO
-- Tabelas para o m�dulo Estoque
CREATE TABLE Estoque (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para estoque
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (�nico)
    quantidade INT NOT NULL CHECK (quantidade > 0), -- Quantidade dispon�vel no estoque
    quantidade_reservada INT NOT NULL CHECK (quantidade_reservada > 0), -- Quantidade reservada no estoque
    quantidade_minima INT NOT NULL CHECK (quantidade_minima > 0), -- Quantidade m�nima no estoque
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de cria��o do estoque
    data_atualizacao DATETIME, -- Data de atualiza��o do estoque
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Precificacao]') AND type in (N'U'))
	DROP TABLE [dbo].[Precificacao]
GO
-- Tabelas para o m�dulo Precifica��o
CREATE TABLE Precificacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para precifica��o
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (�nico)
    preco_lista DECIMAL(10, 2) NOT NULL, -- Pre�o de lista do produto
    data_criacao DATETIME, -- Data de cria��o da precifica��o
    data_atualizacao DATETIME, -- Data de atualiza��o da precifica��o
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Promocao]') AND type in (N'U'))
	DROP TABLE [dbo].[Promocao]
GO
-- Tabela para armazenar promo��es
CREATE TABLE Promocao (
    id INT PRIMARY KEY IDENTITY, -- Identificador �nico para promo��o
    nome VARCHAR(100) NOT NULL, -- Nome da promo��o
    descricao TEXT, -- Descri��o da promo��o
    data_inicio DATETIME, -- Data de in�cio da promo��o
    data_fim DATETIME, -- Data de fim da promo��o
    data_criacao DATETIME, -- Data de cria��o da promo��o
    data_atualizacao DATETIME, -- Data de atualiza��o da promo��o
    tipo_promocao_id INT NOT NULL, -- Identificador do tipo de promo��o
    desconto DECIMAL(10, 2), -- Valor do desconto (por exemplo, 0.9 para 10% de desconto)
    FOREIGN KEY (tipo_promocao_id) REFERENCES TipoPromocao(id) -- Chave estrangeira para a tabela TipoPromocao
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromocaoProduto]') AND type in (N'U'))
	DROP TABLE [dbo].[PromocaoProduto]
GO
-- Tabela para associar promo��es a produtos
CREATE TABLE PromocaoProduto (
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (�nico)
    promocao_id INT NOT NULL, -- Identificador da promo��o associada
    data_criacao DATETIME, -- Data de cria��o da associa��o
    PRIMARY KEY (produto_id, promocao_id), -- Chave prim�ria composta
    FOREIGN KEY (produto_id) REFERENCES Produto(id), -- Chave estrangeira para a tabela Produto
    FOREIGN KEY (promocao_id) REFERENCES Promocao(id) -- Chave estrangeira para a tabela Promocao
);
GO
