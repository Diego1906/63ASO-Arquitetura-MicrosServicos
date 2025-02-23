
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusConta]') AND type in (N'U'))
	DROP TABLE [dbo].[StatusConta]
GO
-- Tabela auxiliar para status de Conta
CREATE TABLE StatusConta (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para status de conta
    nome VARCHAR(50) NOT NULL -- Nome do status da conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TipoPromocao]') AND type in (N'U'))
	DROP TABLE [dbo].[TipoPromocao]
GO
-- Tabela auxiliar para tipos de promoção
CREATE TABLE TipoPromocao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para tipo de promoção
    nome VARCHAR(50) NOT NULL -- Nome do tipo de promoção
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Perfil]') AND type in (N'U'))
	DROP TABLE [dbo].[Perfil]
GO
-- Tabela para perfis de usuário
CREATE TABLE Perfil (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para perfil de usuário
    nome VARCHAR(50) NOT NULL -- Nome do perfil de usuário
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Cliente]') AND type in (N'U'))
	DROP TABLE [dbo].[Cliente]
GO
-- Tabelas para registros de clientes
CREATE TABLE Cliente (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para cliente
    nome VARCHAR(100) NOT NULL, -- Nome do cliente
    email VARCHAR(255) NOT NULL UNIQUE, -- Email do cliente (único)
    telefone VARCHAR(20), -- Telefone do cliente
    data_atualizacao DATETIME -- Data de atualização do registro do cliente
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Conta]') AND type in (N'U'))
	DROP TABLE [dbo].[Conta]
GO
-- Tabela de Conta
CREATE TABLE Conta (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para conta
    cliente_id INT NOT NULL UNIQUE, -- Identificador do cliente associado (único)
    senha_sha256 VARCHAR(64) NOT NULL, -- Hash SHA-256 da senha do cliente
    salt VARCHAR(32) NOT NULL, -- Salt utilizado para a hash da senha
    mfa VARCHAR(50), -- Método de autenticação multifator (MFA) habilitado
    status_id INT NOT NULL, -- Identificador do status da conta
    perfil_id INT NOT NULL DEFAULT 1, -- Identificador do perfil da conta (padrão: Cliente)
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da conta
    data_atualizacao DATETIME, -- Data de atualização da conta
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id), -- Chave estrangeira para a tabela Cliente
    FOREIGN KEY (status_id) REFERENCES StatusConta(id), -- Chave estrangeira para a tabela StatusConta
    FOREIGN KEY (perfil_id) REFERENCES Perfil(id) -- Chave estrangeira para a tabela Perfil
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Endereco]') AND type in (N'U'))
	DROP TABLE [dbo].[Endereco]
GO
-- Tabela de Endereços
CREATE TABLE Endereco (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para endereço
    conta_id INT NOT NULL, -- Identificador da conta associada
    nome VARCHAR(100) NOT NULL, -- Nome do endereço (ex.: Casa, Trabalho)
    endereco VARCHAR(255) NOT NULL, -- Endereço completo
    cidade VARCHAR(100) NOT NULL, -- Cidade
    estado VARCHAR(50) NOT NULL, -- Estado
    cep VARCHAR(20) NOT NULL, -- Código postal
    pais VARCHAR(50) NOT NULL, -- País
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação do endereço
    data_atualizacao DATETIME, -- Data de atualização do endereço
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NivelFidelidade]') AND type in (N'U'))
	DROP TABLE [dbo].[NivelFidelidade]
GO
-- Tabelas para o módulo Fidelidade
CREATE TABLE NivelFidelidade (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para nível de fidelidade
    nome VARCHAR(50) NOT NULL, -- Nome do nível de fidelidade
    desconto_frete DECIMAL(5, 2) NOT NULL, -- Desconto em frete
    desconto_produto DECIMAL(5, 2) NOT NULL -- Desconto em produtos
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Fidelidade]') AND type in (N'U'))
	DROP TABLE [dbo].[Fidelidade]
GO
CREATE TABLE Fidelidade (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para fidelidade
    conta_id INT NOT NULL UNIQUE, -- Identificador da conta associada (único)
    progresso DECIMAL(5,2) NOT NULL, -- Progresso de fidelidade
    nivel_id INT NOT NULL, -- Identificador do nível de fidelidade
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da fidelidade
    data_atualizacao DATETIME, -- Data de atualização da fidelidade
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (nivel_id) REFERENCES NivelFidelidade(id) -- Chave estrangeira para a tabela NivelFidelidade
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carrinho]') AND type in (N'U'))
	DROP TABLE [dbo].[Carrinho]
GO
-- Tabelas para o módulo Carrinho
CREATE TABLE Carrinho (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para carrinho
    conta_id INT NOT NULL UNIQUE, -- Identificador da conta associada (único)
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Categoria]') AND type in (N'U'))
	DROP TABLE [dbo].[Categoria]
GO
-- Tabelas para o módulo Catálogo de Produtos
CREATE TABLE Categoria (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para categoria
    nome VARCHAR(100) NOT NULL, -- Nome da categoria
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da categoria
    data_atualizacao DATETIME -- Data de atualização da categoria
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Produto]') AND type in (N'U'))
	DROP TABLE [dbo].[Produto]
GO
CREATE TABLE Produto (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para produto
    sku VARCHAR(50) NOT NULL UNIQUE, -- SKU do produto (único)
    ean VARCHAR(50) NOT NULL UNIQUE, -- EAN do produto (único)
    nome VARCHAR(100) NOT NULL, -- Nome do produto
    descricao TEXT, -- Descrição do produto
    categoria_id INT, -- Identificador da categoria associada
    ativo BIT NOT NULL, -- Indicador se o produto está ativo
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação do produto
    data_atualizacao DATETIME, -- Data de atualização do produto
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id) -- Chave estrangeira para a tabela Categoria
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CarrinhoItem]') AND type in (N'U'))
	DROP TABLE [dbo].[CarrinhoItem]
GO
CREATE TABLE CarrinhoItem (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para item do carrinho
    carrinho_id INT NOT NULL, -- Identificador do carrinho associado
    produto_id INT NOT NULL, -- Identificador do produto associado
    quantidade INT NOT NULL CHECK (quantidade > 0), -- Quantidade do produto no carrinho
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação do item do carrinho
    data_atualizacao DATETIME, -- Data de atualização do item do carrinho
    UNIQUE (carrinho_id, produto_id), -- Garantir unicidade de produto no carrinho
    FOREIGN KEY (carrinho_id) REFERENCES Carrinho(id), -- Chave estrangeira para a tabela Carrinho
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItensSalvos]') AND type in (N'U'))
	DROP TABLE [dbo].[ItensSalvos]
GO
CREATE TABLE ItensSalvos (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para item salvo
    conta_id INT NOT NULL, -- Identificador da conta associada
    produto_id INT NOT NULL, -- Identificador do produto associado
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação do item salvo
    UNIQUE (conta_id, produto_id), -- Garantir unicidade de produto salvo por conta
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Recomendacao]') AND type in (N'U'))
	DROP TABLE [dbo].[Recomendacao]
GO
-- Tabelas para o módulo Recomendação
CREATE TABLE Recomendacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para recomendação
    conta_id INT NOT NULL, -- Identificador da conta associada
    produto_id INT NOT NULL, -- Identificador do produto associado
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da recomendação
    UNIQUE (conta_id, produto_id), -- Garantir unicidade de produto recomendado por conta
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Busca]') AND type in (N'U'))
	DROP TABLE [dbo].[Busca]
GO
-- Tabelas para o módulo Busca
CREATE TABLE Busca (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para busca
    termo_busca VARCHAR(255) NOT NULL, -- Termo buscado
    conta_id INT NOT NULL, -- Identificador da conta associada
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da busca
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ProdutoMedia]') AND type in (N'U'))
	DROP TABLE [dbo].[ProdutoMedia]
GO
-- Tabela para URLs de imagens e vídeos do produto
CREATE TABLE ProdutoMedia (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para mídia do produto
    produto_id INT NOT NULL, -- Identificador do produto associado
    ordem INT NOT NULL, -- Ordem da mídia do produto, para exibição
    url VARCHAR(255) NOT NULL, -- URL da mídia
    tipo VARCHAR(50) NOT NULL, -- Tipo de mídia: 'Imagem' ou 'Vídeo'
    principal BIT NOT NULL, -- Indicador se a mídia é principal, para exibição em lista de produtos
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da mídia
    data_atualizacao DATETIME, -- Data de atualização da mídia
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Carrousel]') AND type in (N'U'))
	DROP TABLE [dbo].[Carrousel]
GO
CREATE TABLE Carrousel (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para carrossel
    ordem INT NOT NULL, -- Ordem do carrossel
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação do carrossel
    data_atualizacao DATETIME, -- Data de atualização do carrossel
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Estoque]') AND type in (N'U'))
	DROP TABLE [dbo].[Estoque]
GO
-- Tabelas para o módulo Estoque
CREATE TABLE Estoque (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para estoque
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    quantidade INT NOT NULL CHECK (quantidade > 0), -- Quantidade disponível no estoque
    quantidade_reservada INT NOT NULL CHECK (quantidade_reservada > 0), -- Quantidade reservada no estoque
    quantidade_minima INT NOT NULL CHECK (quantidade_minima > 0), -- Quantidade mínima no estoque
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação do estoque
    data_atualizacao DATETIME, -- Data de atualização do estoque
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Precificacao]') AND type in (N'U'))
	DROP TABLE [dbo].[Precificacao]
GO
-- Tabelas para o módulo Precificação
CREATE TABLE Precificacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para precificação
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    preco_lista DECIMAL(10, 2) NOT NULL, -- Preço de lista do produto
    data_criacao DATETIME, -- Data de criação da precificação
    data_atualizacao DATETIME, -- Data de atualização da precificação
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Promocao]') AND type in (N'U'))
	DROP TABLE [dbo].[Promocao]
GO
-- Tabela para armazenar promoções
CREATE TABLE Promocao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para promoção
    nome VARCHAR(100) NOT NULL, -- Nome da promoção
    descricao TEXT, -- Descrição da promoção
    data_inicio DATETIME, -- Data de início da promoção
    data_fim DATETIME, -- Data de fim da promoção
    data_criacao DATETIME, -- Data de criação da promoção
    data_atualizacao DATETIME, -- Data de atualização da promoção
    tipo_promocao_id INT NOT NULL, -- Identificador do tipo de promoção
    desconto DECIMAL(10, 2), -- Valor do desconto (por exemplo, 0.9 para 10% de desconto)
    FOREIGN KEY (tipo_promocao_id) REFERENCES TipoPromocao(id) -- Chave estrangeira para a tabela TipoPromocao
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PromocaoProduto]') AND type in (N'U'))
	DROP TABLE [dbo].[PromocaoProduto]
GO
-- Tabela para associar promoções a produtos
CREATE TABLE PromocaoProduto (
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    promocao_id INT NOT NULL, -- Identificador da promoção associada
    data_criacao DATETIME, -- Data de criação da associação
    PRIMARY KEY (produto_id, promocao_id), -- Chave primária composta
    FOREIGN KEY (produto_id) REFERENCES Produto(id), -- Chave estrangeira para a tabela Produto
    FOREIGN KEY (promocao_id) REFERENCES Promocao(id) -- Chave estrangeira para a tabela Promocao
);
GO
