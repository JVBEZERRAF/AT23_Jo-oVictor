-- 03_automacao_plsql.sql
USE omnichannel_db;

DROP TRIGGER IF EXISTS trg_auditoria_preco;
DELIMITER //
CREATE TRIGGER trg_auditoria_preco
AFTER UPDATE ON produtos
FOR EACH ROW
BEGIN
  IF OLD.preco <> NEW.preco THEN
    INSERT INTO auditoria_preco
      (id_produto, preco_antigo, preco_novo, data_alteracao, usuario)
    VALUES
      (OLD.id_produto, OLD.preco, NEW.preco, NOW(), USER());
  END IF;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS sp_processar_venda;
DELIMITER //
CREATE PROCEDURE sp_processar_venda(
  IN p_id_cliente INT,
  IN p_id_loja INT,
  IN p_id_produto INT,
  IN p_quantidade INT,
  IN p_canal VARCHAR(20),
  IN p_metodo_pagamento VARCHAR(30)
)
BEGIN
  DECLARE v_estoque INT DEFAULT NULL;
  DECLARE v_preco DECIMAL(10,2);
  DECLARE v_id_pedido INT;
  DECLARE v_total DECIMAL(10,2);

  DECLARE EXIT HANDLER FOR SQLEXCEPTION
  BEGIN
    ROLLBACK;
    RESIGNAL;
  END;

  IF p_quantidade <= 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A quantidade deve ser maior que zero.';
  END IF;

  START TRANSACTION;

  SELECT quantidade INTO v_estoque
  FROM estoque
  WHERE id_loja = p_id_loja AND id_produto = p_id_produto
  FOR UPDATE;

  IF v_estoque IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nao existe estoque para esse produto nessa loja.';
  END IF;

  IF v_estoque < p_quantidade THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente.';
  END IF;

  SELECT preco INTO v_preco FROM produtos
  WHERE id_produto = p_id_produto AND ativo = 1;

  IF v_preco IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Produto inexistente ou inativo.';
  END IF;

  SET v_total = v_preco * p_quantidade;

  INSERT INTO pedidos (id_cliente,id_loja,canal,status,total)
  VALUES (p_id_cliente,p_id_loja,p_canal,'Pago',v_total);
  SET v_id_pedido = LAST_INSERT_ID();

  INSERT INTO itens_pedido (id_pedido,id_produto,quantidade,preco_unitario,subtotal)
  VALUES (v_id_pedido,p_id_produto,p_quantidade,v_preco,v_total);

  INSERT INTO pagamentos (id_pedido,metodo,valor,status)
  VALUES (v_id_pedido,p_metodo_pagamento,v_total,'Aprovado');

  UPDATE estoque
  SET quantidade = quantidade - p_quantidade
  WHERE id_loja = p_id_loja AND id_produto = p_id_produto;

  COMMIT;
  SELECT v_id_pedido AS id_pedido_criado, v_total AS total_venda;
END //
DELIMITER ;

-- TESTE DA TRIGGER: deve inserir uma nova linha na auditoria_preco.
-- UPDATE produtos SET preco = preco + 1.00 WHERE id_produto = 1;
-- SELECT * FROM auditoria_preco ORDER BY id_auditoria DESC;

-- TESTE DA PROCEDURE (cliente 1, loja 1, produto 3, quantidade 2):
-- CALL sp_processar_venda(1, 1, 3, 2, 'Online', 'Pix');
-- SELECT * FROM pedidos ORDER BY id_pedido DESC;
-- SELECT * FROM estoque WHERE id_loja=1 AND id_produto=3;
