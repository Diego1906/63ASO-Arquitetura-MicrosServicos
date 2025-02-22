-- Tabela auxiliar para status de Conta
CREATE TABLE StatusConta (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para status de conta
    nome VARCHAR(50) NOT NULL -- Nome do status da conta
);

-- Tabela auxiliar para status de Entrega
CREATE TABLE StatusEntrega (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para status de entrega
    nome VARCHAR(50) NOT NULL -- Nome do status de entrega
);

-- Tabela auxiliar para status de Pagamento
CREATE TABLE StatusPagamento (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para status de pagamento
    nome VARCHAR(50) NOT NULL -- Nome do status de pagamento
);

-- Tabela auxiliar para status de Pedido
CREATE TABLE StatusPedido (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para status de pedido
    nome VARCHAR(50) NOT NULL -- Nome do status de pedido
);

-- Tabela auxiliar para status de Notificação
CREATE TABLE StatusNotificacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para status de notificação
    nome VARCHAR(50) NOT NULL -- Nome do status de notificação
);

-- Tabela auxiliar para tipos de promoção
CREATE TABLE TipoPromocao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para tipo de promoção
    nome VARCHAR(50) NOT NULL -- Nome do tipo de promoção
);

-- Tabela para perfis de usuário
CREATE TABLE Perfil (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para perfil de usuário
    nome VARCHAR(50) NOT NULL -- Nome do perfil de usuário
);

-- Tabela para armazenar modalidades de entrega com prazo em dias e ID de entrega rápida
CREATE TABLE ModalidadeEntrega (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para modalidade de entrega
    nome VARCHAR(50) NOT NULL, -- Nome da modalidade de entrega
    prazo_entrega INT NOT NULL, -- Prazo de entrega em dias
    entrega_rapida_id VARCHAR(100) UNIQUE -- ID correspondente da Entrega Rápida
);

-- Tabelas para registros de clientes
CREATE TABLE Cliente (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para cliente
    nome VARCHAR(100) NOT NULL, -- Nome do cliente
    email VARCHAR(255) NOT NULL UNIQUE, -- Email do cliente (único)
    telefone VARCHAR(20), -- Telefone do cliente
    data_atualizacao DATETIME -- Data de atualização do registro do cliente
);

-- Tabela de Conta
CREATE TABLE Conta (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para conta
    cliente_id INT NOT NULL UNIQUE, -- Identificador do cliente associado (único)
    senha_sha256 VARCHAR(64) NOT NULL, -- Hash SHA-256 da senha do cliente
    salt VARCHAR(32) NOT NULL, -- Salt utilizado para a hash da senha
    mfa VARCHAR(50), -- Método de autenticação multifator (MFA) habilitado
    status_id INT NOT NULL, -- Identificador do status da conta
    perfil_id INT NOT NULL DEFAULT 1, -- Identificador do perfil da conta (padrão: Cliente)
    data_criacao DATETIME, -- Data de criação da conta
    data_atualizacao DATETIME, -- Data de atualização da conta
    FOREIGN KEY (cliente_id) REFERENCES Cliente(id), -- Chave estrangeira para a tabela Cliente
    FOREIGN KEY (status_id) REFERENCES StatusConta(id), -- Chave estrangeira para a tabela StatusConta
    FOREIGN KEY (perfil_id) REFERENCES Perfil(id) -- Chave estrangeira para a tabela Perfil
);

-- Tabela de Pedido
CREATE TABLE Pedido (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para pedido
    conta_id INT NOT NULL, -- Identificador da conta associada
    status_id INT NOT NULL, -- Identificador do status do pedido
    data_criacao DATETIME, -- Data de criação do pedido
    data_atualizacao DATETIME, -- Data de atualização do pedido
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (status_id) REFERENCES StatusPedido(id) -- Chave estrangeira para a tabela StatusPedido
);

-- Tabela de Entrega com referência à modalidade de entrega e custo do frete
CREATE TABLE Entrega (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para entrega
    pedido_id INT NOT NULL, -- Identificador do pedido associado
    status_id INT NOT NULL, -- Identificador do status da entrega
    modalidade_id INT NOT NULL, -- Identificador da modalidade de entrega
    custo_frete DECIMAL(10, 2) NOT NULL, -- Custo do frete
    desconto_frete DECIMAL(5, 2), -- Desconto em frete
    data_criacao DATETIME, -- Data de criação da entrega
    data_atualizacao DATETIME, -- Data de atualização da entrega
	data_prevista DATETIME, -- Data prevista para a entrega
    pedido_entrega_rapida_id VARCHAR(100), -- ID do pedido de entrega solicitado na Entrega Rápida
    endereco_entrega VARCHAR(255) NOT NULL, -- Endereço de entrega
    FOREIGN KEY (pedido_id) REFERENCES Pedido(id), -- Chave estrangeira para a tabela Pedido
    FOREIGN KEY (modalidade_id) REFERENCES ModalidadeEntrega(id), -- Chave estrangeira para a tabela ModalidadeEntrega
    FOREIGN KEY (status_id) REFERENCES StatusEntrega(id) -- Chave estrangeira para a tabela StatusEntrega
);

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
    data_criacao DATETIME, -- Data de criação do endereço
    data_atualizacao DATETIME, -- Data de atualização do endereço
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);

-- Tabelas para o módulo Fidelidade
CREATE TABLE NivelFidelidade (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para nível de fidelidade
    nome VARCHAR(50) NOT NULL, -- Nome do nível de fidelidade
    desconto_frete DECIMAL(5, 2) NOT NULL, -- Desconto em frete
    desconto_produto DECIMAL(5, 2) NOT NULL -- Desconto em produtos
);

CREATE TABLE Fidelidade (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para fidelidade
    conta_id INT NOT NULL UNIQUE, -- Identificador da conta associada (único)
    progresso DECIMAL(5,2) NOT NULL, -- Progresso de fidelidade
    nivel_id INT NOT NULL, -- Identificador do nível de fidelidade
    data_criacao DATETIME, -- Data de criação da fidelidade
    data_atualizacao DATETIME, -- Data de atualização da fidelidade
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (nivel_id) REFERENCES NivelFidelidade(id) -- Chave estrangeira para a tabela NivelFidelidade
);

-- Tabelas para o módulo Carrinho
CREATE TABLE Carrinho (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para carrinho
    conta_id INT NOT NULL UNIQUE, -- Identificador da conta associada (único)
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);

-- Tabelas para o módulo Catálogo de Produtos
CREATE TABLE Categoria (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para categoria
    nome VARCHAR(100) NOT NULL, -- Nome da categoria
    data_criacao DATETIME, -- Data de criação da categoria
    data_atualizacao DATETIME -- Data de atualização da categoria
);

CREATE TABLE Produto (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para produto
    sku VARCHAR(50) NOT NULL UNIQUE, -- SKU do produto (único)
    ean VARCHAR(50) NOT NULL UNIQUE, -- EAN do produto (único)
    nome VARCHAR(100) NOT NULL, -- Nome do produto
    descricao TEXT, -- Descrição do produto
    categoria_id INT, -- Identificador da categoria associada
    ativo BIT NOT NULL, -- Indicador se o produto está ativo
    data_criacao DATETIME, -- Data de criação do produto
    data_atualizacao DATETIME, -- Data de atualização do produto
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id) -- Chave estrangeira para a tabela Categoria
);

CREATE TABLE CarrinhoItem (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para item do carrinho
    carrinho_id INT NOT NULL, -- Identificador do carrinho associado
    produto_id INT NOT NULL, -- Identificador do produto associado
    quantidade INT NOT NULL, -- Quantidade do produto no carrinho
    data_criacao DATETIME, -- Data de criação do item do carrinho
    data_atualizacao DATETIME, -- Data de atualização do item do carrinho
    UNIQUE (carrinho_id, produto_id), -- Garantir unicidade de produto no carrinho
    FOREIGN KEY (carrinho_id) REFERENCES Carrinho(id), -- Chave estrangeira para a tabela Carrinho
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

CREATE TABLE ItensSalvos (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para item salvo
    conta_id INT NOT NULL, -- Identificador da conta associada
    produto_id INT NOT NULL, -- Identificador do produto associado
    data_criacao DATETIME, -- Data de criação do item salvo
    UNIQUE (conta_id, produto_id), -- Garantir unicidade de produto salvo por conta
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

-- Tabelas para o módulo Pedido
CREATE TABLE PedidoItem (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para item do pedido
    pedido_id INT NOT NULL, -- Identificador do pedido associado
    produto_id INT NOT NULL, -- Identificador do produto associado
    quantidade INT NOT NULL, -- Quantidade do produto no pedido
    preco_individual DECIMAL(10, 2) NOT NULL, -- Preço individual do item no momento da criação do pedido
    desconto_produto DECIMAL(5, 2), -- Desconto no produto
    data_criacao DATETIME, -- Data de criação do item do pedido
    data_atualizacao DATETIME, -- Data de atualização do item do pedido
    UNIQUE (pedido_id, produto_id), -- Garantir unicidade de produto no pedido
    FOREIGN KEY (pedido_id) REFERENCES Pedido(id), -- Chave estrangeira para a tabela Pedido
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

-- Tabelas para o módulo Recomendação
CREATE TABLE Recomendacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para recomendação
    conta_id INT NOT NULL, -- Identificador da conta associada
    produto_id INT NOT NULL, -- Identificador do produto associado
    data_criacao DATETIME, -- Data de criação da recomendação
    UNIQUE (conta_id, produto_id), -- Garantir unicidade de produto recomendado por conta
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

-- Tabelas para o módulo Busca
CREATE TABLE Busca (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para busca
    termo_busca VARCHAR(255) NOT NULL, -- Termo buscado
    conta_id INT NOT NULL, -- Identificador da conta associada
    data_criacao DATETIME, -- Data de criação da busca
    FOREIGN KEY (conta_id) REFERENCES Conta(id) -- Chave estrangeira para a tabela Conta
);


-- Tabela para URLs de imagens e vídeos do produto
CREATE TABLE ProdutoMedia (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para mídia do produto
    produto_id INT NOT NULL, -- Identificador do produto associado
    ordem INT NOT NULL, -- Ordem da mídia do produto, para exibição
    url VARCHAR(255) NOT NULL, -- URL da mídia
    tipo VARCHAR(50) NOT NULL, -- Tipo de mídia: 'Imagem' ou 'Vídeo'
    principal BIT NOT NULL, -- Indicador se a mídia é principal, para exibição em lista de produtos
    data_criacao DATETIME, -- Data de criação da mídia
    data_atualizacao DATETIME, -- Data de atualização da mídia
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

CREATE TABLE Carrousel (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para carrossel
    ordem INT NOT NULL, -- Ordem do carrossel
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    data_criacao DATETIME, -- Data de criação do carrossel
    data_atualizacao DATETIME, -- Data de atualização do carrossel
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

-- Tabelas para o módulo Notificação
CREATE TABLE NotificacaoTemplate (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para template de notificação
    nome VARCHAR(100) NOT NULL, -- Nome do template
    titulo VARCHAR(50) NOT NULL, -- Título do template
    mensagem TEXT NOT NULL -- Mensagem do template
);

CREATE TABLE Notificacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para notificação
    conta_id INT NOT NULL, -- Identificador da conta associada
    template_id INT NOT NULL, -- Identificador do template de notificação
    mensagem_variaveis TEXT NOT NULL, -- JSON com as variáveis da mensagem
    tipo VARCHAR(50) NOT NULL, -- Tipo de notificação: 'sms', 'email', 'push'
    status_id INT NOT NULL, -- Identificador do status da notificação
    data_criacao DATETIME, -- Data de criação da notificação
    data_atualizacao DATETIME, -- Data de atualização da notificação
    FOREIGN KEY (conta_id) REFERENCES Conta(id), -- Chave estrangeira para a tabela Conta
    FOREIGN KEY (template_id) REFERENCES NotificacaoTemplate(id), -- Chave estrangeira para a tabela NotificacaoTemplate
    FOREIGN KEY (status_id) REFERENCES StatusNotificacao(id) -- Chave estrangeira para a tabela StatusNotificacao
);

-- Tabelas para o módulo Estoque
CREATE TABLE Estoque (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para estoque
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    quantidade INT NOT NULL, -- Quantidade disponível no estoque
    quantidade_reservada INT NOT NULL, -- Quantidade reservada no estoque
    quantidade_minima INT NOT NULL, -- Quantidade mínima no estoque
    data_criacao DATETIME, -- Data de criação do estoque
    data_atualizacao DATETIME, -- Data de atualização do estoque
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

-- Tabelas para o módulo Precificação
CREATE TABLE Precificacao (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para precificação
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    preco_lista DECIMAL(10, 2) NOT NULL, -- Preço de lista do produto
    data_criacao DATETIME, -- Data de criação da precificação
    data_atualizacao DATETIME, -- Data de atualização da precificação
    FOREIGN KEY (produto_id) REFERENCES Produto(id) -- Chave estrangeira para a tabela Produto
);

-- Tabela para métodos de pagamento
CREATE TABLE MetodoPagamento (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para método de pagamento
    nome VARCHAR(50) NOT NULL, -- Nome do método de pagamento
    paguei_id VARCHAR(100) NOT NULL UNIQUE -- ID correspondente na Paguei
);

-- Tabelas para o módulo Pagamento
CREATE TABLE Pagamento (
    id INT PRIMARY KEY IDENTITY, -- Identificador único para pagamento
    pedido_id INT NOT NULL, -- Identificador do pedido associado
    status_id INT NOT NULL, -- Identificador do status do pagamento
    metodo_pagamento_id INT NOT NULL, -- Identificador do método de pagamento
    desconto_pagamento DECIMAL(5, 2), -- Desconto no pagamento
    pedido_paguei_id VARCHAR(100), -- ID do pedido de pagamento gerado na Paguei para o método de pagamento correspondente
    preco_total DECIMAL(10, 2) NOT NULL, -- Preço total do pagamento
    data_criacao DATETIME, -- Data de criação do pagamento
    data_atualizacao DATETIME, -- Data de atualização do pagamento
    FOREIGN KEY (pedido_id) REFERENCES Pedido(id), -- Chave estrangeira para a tabela Pedido
    FOREIGN KEY (metodo_pagamento_id) REFERENCES MetodoPagamento(id), -- Chave estrangeira para a tabela MetodoPagamento
    FOREIGN KEY (status_id) REFERENCES StatusPagamento(id) -- Chave estrangeira para a tabela StatusPagamento
);

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

-- Tabela para associar promoções a produtos
CREATE TABLE PromocaoProduto (
    produto_id INT NOT NULL UNIQUE, -- Identificador do produto associado (único)
    promocao_id INT NOT NULL, -- Identificador da promoção associada
    data_criacao DATETIME, -- Data de criação da associação
    PRIMARY KEY (produto_id, promocao_id), -- Chave primária composta
    FOREIGN KEY (produto_id) REFERENCES Produto(id), -- Chave estrangeira para a tabela Produto
    FOREIGN KEY (promocao_id) REFERENCES Promocao(id) -- Chave estrangeira para a tabela Promocao
);

-- Tabela para associar promoções a modalidades de entrega
CREATE TABLE PromocaoModalidadeEntrega (
    promocao_id INT NOT NULL, -- Identificador da promoção associada
    modalidade_id INT NOT NULL UNIQUE, -- Identificador da modalidade de entrega associada (único)
    data_criacao DATETIME, -- Data de criação da associação
    PRIMARY KEY (promocao_id, modalidade_id), -- Chave primária composta
    FOREIGN KEY (promocao_id) REFERENCES Promocao(id), -- Chave estrangeira para a tabela Promocao
    FOREIGN KEY (modalidade_id) REFERENCES ModalidadeEntrega(id) -- Chave estrangeira para a tabela ModalidadeEntrega
);

-- Tabela para associar promoções a modalidades de pagamento
CREATE TABLE PromocaoMetodoPagamento (
    promocao_id INT NOT NULL, -- Identificador da promoção associada
    metodo_pagamento_id INT NOT NULL UNIQUE, -- Identificador do método de pagamento associado (único)
    data_criacao DATETIME, -- Data de criação da associação
    PRIMARY KEY (promocao_id, metodo_pagamento_id), -- Chave primária composta
    FOREIGN KEY (promocao_id) REFERENCES Promocao(id), -- Chave estrangeira para a tabela Promocao
    FOREIGN KEY (metodo_pagamento_id) REFERENCES MetodoPagamento(id) -- Chave estrangeira para a tabela MetodoPagamento
);

