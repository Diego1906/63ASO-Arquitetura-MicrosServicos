USE FiapStore_NotificacaoDataBase
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatusNotificacao]') AND type in (N'U'))
	DROP TABLE [dbo].[StatusNotificacao]
GO
CREATE TABLE StatusNotificacao (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para status de notificação
    nome VARCHAR(50) NOT NULL -- Nome do status de notificação
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[NotificacaoTemplate]') AND type in (N'U'))
	DROP TABLE [dbo].[NotificacaoTemplate]
GO
CREATE TABLE NotificacaoTemplate (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para template de notificação
    nome VARCHAR(100) NOT NULL, -- Nome do template
    titulo VARCHAR(50) NOT NULL, -- Título do template
    mensagem TEXT NOT NULL -- Mensagem do template
);
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Notificacao]') AND type in (N'U'))
	DROP TABLE [dbo].[Notificacao]
GO
CREATE TABLE Notificacao (
    id INT PRIMARY KEY IDENTITY(1,1) NOT NULL, -- Identificador único para notificação
    conta_id INT NOT NULL, -- Identificador da conta associada. Referência externa (Conta)
    template_id INT NOT NULL, -- Identificador do template de notificação
    mensagem_variaveis TEXT NOT NULL, -- JSON com as variáveis da mensagem
    tipo VARCHAR(50) NOT NULL, -- Tipo de notificação: 'sms', 'email', 'push'
    status_id INT NOT NULL, -- Identificador do status da notificação
    data_criacao DATETIME DEFAULT GETDATE(), -- Data de criação da notificação
    data_atualizacao DATETIME, -- Data de atualização da notificação
    FOREIGN KEY (template_id) REFERENCES NotificacaoTemplate(id), -- Chave estrangeira para a tabela NotificacaoTemplate
    FOREIGN KEY (status_id) REFERENCES StatusNotificacao(id) -- Chave estrangeira para a tabela StatusNotificacao
);
GO
