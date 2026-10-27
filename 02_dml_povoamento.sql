-- 02_dml_povoamento.sql
USE omnichannel_db;

INSERT INTO clientes (nome,email,telefone) VALUES
('Ana Souza','ana.souza@example.com','81990001001'),
('Bruno Lima','bruno.lima@example.com','81990001002'),
('Carla Mendes','carla.mendes@example.com','81990001003'),
('Diego Alves','diego.alves@example.com','81990001004'),
('Eduarda Costa','eduarda.costa@example.com','81990001005');

INSERT INTO produtos (nome,descricao,preco,ativo) VALUES
('Smartphone Galaxy S23','Smartphone 128 GB',2499.90,1),
('Notebook Dell Inspiron','Notebook para trabalho',3899.00,1),
('Fone Bluetooth','Fone sem fio',199.90,1),
('Monitor 24 polegadas','Monitor Full HD',799.00,1),
('Teclado USB','Teclado ABNT2',89.90,1);

INSERT INTO lojas (nome,cidade,tipo) VALUES
('Loja Recife Centro','Recife','Fisica'),
('Loja Boa Viagem','Recife','Fisica'),
('Centro de Distribuicao Recife','Recife','Centro de Distribuicao'),
('Loja Olinda','Olinda','Fisica'),
('Canal Online','Recife','Online');

INSERT INTO estoque (id_loja,id_produto,quantidade) VALUES
(1,1,12),(1,2,5),(1,3,30),(2,4,10),(5,5,50);

INSERT INTO pedidos (id_cliente,id_loja,canal,status,total) VALUES
(1,5,'Online','Pago',2499.90),
(2,1,'Loja fisica','Pago',3899.00),
(3,5,'Aplicativo','Pendente',199.90),
(4,2,'Loja fisica','Pago',799.00),
(5,5,'Online','Pago',89.90);

INSERT INTO itens_pedido (id_pedido,id_produto,quantidade,preco_unitario,subtotal) VALUES
(1,1,1,2499.90,2499.90),
(2,2,1,3899.00,3899.00),
(3,3,1,199.90,199.90),
(4,4,1,799.00,799.00),
(5,5,1,89.90,89.90);

INSERT INTO pagamentos (id_pedido,metodo,valor,status) VALUES
(1,'Cartao',2499.90,'Aprovado'),
(2,'Pix',3899.00,'Aprovado'),
(3,'Cartao',199.90,'Pendente'),
(4,'Pix',799.00,'Aprovado'),
(5,'Boleto',89.90,'Aprovado');

-- Dados de exemplo para demonstrar a tabela de auditoria.
-- A trigger tambem registrara automaticamente futuras alteracoes de preco.
INSERT INTO auditoria_preco (id_produto,preco_antigo,preco_novo,usuario) VALUES
(1,2599.90,2499.90,'carga_inicial'),
(2,3999.00,3899.00,'carga_inicial'),
(3,219.90,199.90,'carga_inicial'),
(4,829.00,799.00,'carga_inicial'),
(5,99.90,89.90,'carga_inicial');

-- Validacao: confira os totais retornados.
SELECT * FROM clientes;
SELECT * FROM produtos;
SELECT * FROM lojas;
SELECT * FROM estoque;
SELECT * FROM pedidos;
SELECT * FROM itens_pedido;
SELECT * FROM pagamentos;
SELECT * FROM auditoria_preco;
