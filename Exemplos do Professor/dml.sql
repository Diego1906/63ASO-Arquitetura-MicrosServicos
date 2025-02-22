-- Inserindo status de Conta
-- Insere diferentes status que uma conta de usuário pode ter.
INSERT INTO StatusConta (nome) VALUES 
('Ativa'), -- A conta está ativa e pode ser usada normalmente.
('Desativada'), -- A conta está desativada e não pode ser usada.
('Exclusão Solicitada'), -- O usuário solicitou a exclusão da conta.
('Exclusão Concluída'); -- A exclusão da conta foi concluída.

/*
INSERT INTO StatusConta (nome) 
VALUES 
	('Ativa'),
	('Desativada'), 
	('Exclusão Solicitada'),
	('Exclusão Concluída'); 
*/

-- Inserindo status de Entrega
-- Insere diferentes status que uma entrega pode ter durante seu ciclo de vida.
INSERT INTO StatusEntrega (nome) VALUES 
('Pendente'), -- A entrega está pendente, aguardando processamento.
('Rejeitada'), -- A entrega foi rejeitada.
('Aceita'), -- A entrega foi aceita e está pronta para ser processada.
('Em Andamento'), -- A entrega está em andamento.
('Concluída'), -- A entrega foi concluída com sucesso.
('Cancelada'); -- A entrega foi cancelada.

/*
INSERT INTO StatusEntrega (nome) VALUES 
('Pendente'),
('Rejeitada'),
('Aceita'),
('Em Andamento'),
('Concluída'),
('Cancelada');
*/

-- Inserindo status de Pagamento
-- Insere diferentes status que um pagamento pode ter durante seu ciclo de vida.
INSERT INTO StatusPagamento (nome) VALUES 
('Pendente'), -- O pagamento está pendente, aguardando processamento.
('Aprovado'), -- O pagamento foi aprovado.
('Rejeitado'), -- O pagamento foi rejeitado.
('Cancelado'); -- O pagamento foi cancelado.

INSERT INTO StatusPagamento (nome) VALUES 
('Pendente'),
('Aprovado'),
('Rejeitado'),
('Cancelado');




-- Inserindo status de Pedido
-- Insere diferentes status que um pedido pode ter durante seu ciclo de vida.
INSERT INTO StatusPedido (nome) VALUES 
('Pendente'), -- O pedido está pendente, aguardando confirmação.
('Rejeitado'), -- O pedido foi rejeitado.
('Confirmado'), -- O pedido foi confirmado. Só é considerado Confirmado após reserva de estoque ser efetuada com sucesso, o pagamento estar com status de Aprovado, entrega estar com status de Aceita.
('Enviado'), -- O pedido foi enviado.
('Entregue'), -- O pedido foi entregue ao cliente.
('Devolvido'), -- O pedido foi devolvido.
('Reembolsado'), -- O pedido foi reembolsado.
('Concluído'), -- O pedido foi concluído com sucesso.
('Cancelado'); -- O pedido foi cancelado.

-- Inserindo status de Notificação
-- Insere diferentes status que uma notificação pode ter durante seu ciclo de vida.
INSERT INTO StatusNotificacao (nome) VALUES 
('Pendente'), -- A notificação está pendente, aguardando envio.
('Enviado'), -- A notificação foi enviada.
('Erro'); -- Houve um erro ao tentar enviar a notificação.

-- Inserindo tipos de promoção
-- Insere diferentes tipos de promoções que podem ser aplicadas.
INSERT INTO TipoPromocao (nome) VALUES 
('Produto'), -- Promoção aplicada a produtos.
('Modalidade Entrega'), -- Promoção aplicada a modalidades de entrega.
('Modalidade Pagamento'); -- Promoção aplicada a métodos de pagamento.

-- Inserindo perfis de usuário
-- Insere diferentes perfis de usuário na plataforma.
INSERT INTO Perfil (nome) VALUES 
('Cliente'), -- Perfil padrão de cliente.
('Backoffice'), -- Perfil de funcionário do backoffice.
('Admin'); -- Perfil de administrador da plataforma.

-- Inserindo modalidades de entrega
-- Insere diferentes modalidades de entrega disponíveis.
INSERT INTO ModalidadeEntrega (nome, prazo_entrega, entrega_rapida_id) VALUES 
('Entrega Hoje', 0, 'ENT_HOJE'), -- Entrega no mesmo dia.
('Entrega Rápida', 2, 'ENT_RAPIDA'), -- Entrega rápida em 2 dias.
('Entrega Padrão', 5, 'ENT_PADRAO'); -- Entrega padrão em 5 dias.

-- Inserindo níveis de fidelidade
-- Insere diferentes níveis de fidelidade com seus respectivos descontos.
INSERT INTO NivelFidelidade (nome, desconto_frete, desconto_produto) VALUES 
('Bronze', 0.05, 0.0), -- Nível Bronze com 5% de desconto no frete.
('Prata', 0.10, 0.05), -- Nível Prata com 10% de desconto no frete e 5% em produtos.
('Ouro', 0.15, 0.10), -- Nível Ouro com 15% de desconto no frete e 10% em produtos.
('Platina', 0.20, 0.15); -- Nível Platina com 20% de desconto no frete e 15% em produtos.

-- Inserindo métodos de pagamento
-- Insere diferentes métodos de pagamento disponíveis.
INSERT INTO MetodoPagamento (nome, paguei_id) VALUES 
('Cartão de Crédito', 'CARTAO_CREDITO'), -- Pagamento com cartão de crédito.
('Boleto', 'BOLETO'), -- Pagamento com boleto bancário.
('Cartão de Débito', 'CARTAO_DEBITO'), -- Pagamento com cartão de débito.
('PIX', 'PIX'); -- Pagamento com PIX.
