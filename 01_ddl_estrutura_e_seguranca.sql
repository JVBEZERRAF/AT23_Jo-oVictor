-- 01_ddl_estrutura_e_seguranca.sql
-- Projeto: Sistema de Gestao OmniChannel
-- Execute no MySQL Workbench com uma conta que tenha permissao para criar banco/usuarios.

CREATE DATABASE IF NOT EXISTS omnichannel_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE omnichannel_db;

CREATE TABLE IF NOT EXISTS clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  email VARCHAR(150) NOT NULL UNIQUE,
  telefone VARCHAR(25),
  data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produtos (
  id_produto INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  descricao VARCHAR(255),
  preco DECIMAL(10,2) NOT NULL,
  ativo TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT chk_produto_preco CHECK (preco >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS lojas (
  id_loja INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(120) NOT NULL,
  cidade VARCHAR(80) NOT NULL,
  tipo VARCHAR(20) NOT NULL DEFAULT 'Fisica',
  CONSTRAINT chk_loja_tipo CHECK (tipo IN ('Fisica','Centro de Distribuicao','Online'))
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS estoque (
  id_estoque INT AUTO_INCREMENT PRIMARY KEY,
  id_loja INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL DEFAULT 0,
  atualizado_em DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT uq_estoque_loja_produto UNIQUE (id_loja, id_produto),
  CONSTRAINT chk_estoque_quantidade CHECK (quantidade >= 0),
  CONSTRAINT fk_estoque_loja FOREIGN KEY (id_loja) REFERENCES lojas(id_loja),
  CONSTRAINT fk_estoque_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pedidos (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT NOT NULL,
  id_loja INT NOT NULL,
  data_pedido DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  canal VARCHAR(20) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Pendente',
  total DECIMAL(10,2) NOT NULL DEFAULT 0,
  CONSTRAINT chk_pedido_canal CHECK (canal IN ('Online','Loja fisica','Aplicativo')),
  CONSTRAINT chk_pedido_status CHECK (status IN ('Pendente','Pago','Cancelado','Enviado')),
  CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
  CONSTRAINT fk_pedido_loja FOREIGN KEY (id_loja) REFERENCES lojas(id_loja)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS itens_pedido (
  id_item INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  id_produto INT NOT NULL,
  quantidade INT NOT NULL,
  preco_unitario DECIMAL(10,2) NOT NULL,
  subtotal DECIMAL(10,2) NOT NULL,
  CONSTRAINT chk_item_quantidade CHECK (quantidade > 0),
  CONSTRAINT fk_item_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
  CONSTRAINT fk_item_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS pagamentos (
  id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT NOT NULL,
  metodo VARCHAR(30) NOT NULL,
  valor DECIMAL(10,2) NOT NULL,
  status VARCHAR(20) NOT NULL DEFAULT 'Aprovado',
  data_pagamento DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT uq_pagamento_pedido UNIQUE (id_pedido),
  CONSTRAINT fk_pagamento_pedido FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS auditoria_preco (
  id_auditoria INT AUTO_INCREMENT PRIMARY KEY,
  id_produto INT NOT NULL,
  preco_antigo DECIMAL(10,2) NOT NULL,
  preco_novo DECIMAL(10,2) NOT NULL,
  data_alteracao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  usuario VARCHAR(100) NOT NULL,
  CONSTRAINT fk_auditoria_produto FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
) ENGINE=InnoDB;

CREATE INDEX idx_pedidos_data ON pedidos(data_pedido);
CREATE INDEX idx_itens_produto ON itens_pedido(id_produto);

-- Conta de exemplo com permissao somente de leitura nos produtos.
-- Altere a senha antes de usar em ambiente real.
CREATE USER IF NOT EXISTS 'atendente_omni'@'localhost' IDENTIFIED BY 'Troque_Esta_Senha123!';
GRANT SELECT ON omnichannel_db.produtos TO 'atendente_omni'@'localhost';
FLUSH PRIVILEGES;
