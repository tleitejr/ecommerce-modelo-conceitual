-- =====================================================================
-- 0) Configuração do banco
-- =====================================================================
CREATE DATABASE IF NOT EXISTS loja
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE loja;

-- =====================================================================
-- 1) CLIENTE (superclasse) + especialização PF / PJ
-- =====================================================================
CREATE TABLE CLIENTE (
    id_cliente     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    email          VARCHAR(255)    NOT NULL,
    telefone       VARCHAR(20),
    data_cadastro  DATE            NOT NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uk_cliente_email (email)
) ENGINE=InnoDB;

CREATE TABLE PESSOA_FISICA (
    id_cliente     BIGINT UNSIGNED NOT NULL,
    nome_completo  VARCHAR(200)    NOT NULL,
    cpf            CHAR(11)        NOT NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uk_pf_cpf (cpf),
    CONSTRAINT fk_pf_cliente
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PESSOA_JURIDICA (
    id_cliente     BIGINT UNSIGNED NOT NULL,
    razao_social   VARCHAR(200)    NOT NULL,
    nome_fantasia  VARCHAR(200),
    cnpj           CHAR(14)        NOT NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uk_pj_cnpj (cnpj),
    CONSTRAINT fk_pj_cliente
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 2) Dados do cliente
-- =====================================================================
CREATE TABLE ENDERECO_CLIENTE (
    id_endereco_cliente BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente          BIGINT UNSIGNED NOT NULL,
    logradouro          VARCHAR(200)    NOT NULL,
    numero              VARCHAR(20),
    complemento         VARCHAR(100),
    bairro              VARCHAR(100),
    cidade              VARCHAR(100)    NOT NULL,
    uf                  CHAR(2),
    cep                 CHAR(8),
    pais                VARCHAR(80)     NOT NULL DEFAULT 'Brasil',
    PRIMARY KEY (id_endereco_cliente),
    KEY idx_ec_cliente (id_cliente),
    CONSTRAINT fk_ec_cliente
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE FORMA_PAGAMENTO (
    id_forma_pagamento      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente              BIGINT UNSIGNED NOT NULL,
    tipo_forma_pagamento    VARCHAR(30)     NOT NULL,
    titular                 VARCHAR(150),
    validade                CHAR(7),        -- formato MM/AAAA
    identificador_seguro    VARCHAR(50),
    ultimos_digitos         CHAR(4),
    PRIMARY KEY (id_forma_pagamento),
    KEY idx_fp_cliente (id_cliente),
    CONSTRAINT fk_fp_cliente
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id_cliente)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 3) PEDIDO e relacionamentos diretos
-- =====================================================================
CREATE TABLE PEDIDO (
    id_pedido                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente               BIGINT UNSIGNED NOT NULL,
    data_pedido              DATE            NOT NULL,
    status_pedido            VARCHAR(30)     NOT NULL,
    valor_frete_contratado   DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    data_limite_devolucao    DATE,
    PRIMARY KEY (id_pedido),
    KEY idx_pedido_cliente (id_cliente),
    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (id_cliente) REFERENCES CLIENTE (id_cliente)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- PEDIDO (1) --- (1) ENDERECO_ENTREGA : UNIQUE em id_pedido garante 1:1
CREATE TABLE ENDERECO_ENTREGA (
    id_endereco_entrega BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido           BIGINT UNSIGNED NOT NULL,
    logradouro          VARCHAR(200)    NOT NULL,
    numero              VARCHAR(20),
    complemento         VARCHAR(100),
    bairro              VARCHAR(100),
    cidade              VARCHAR(100)    NOT NULL,
    uf                  CHAR(2),
    cep                 CHAR(8),
    pais                VARCHAR(80)     NOT NULL DEFAULT 'Brasil',
    PRIMARY KEY (id_endereco_entrega),
    UNIQUE KEY uk_ee_pedido (id_pedido),
    CONSTRAINT fk_ee_pedido
        FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 4) Catálogo de produtos e fornecedores
-- =====================================================================
CREATE TABLE PRODUTO (
    id_produto      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    sku             VARCHAR(50)     NOT NULL,
    nome            VARCHAR(200)    NOT NULL,
    descricao       TEXT,
    preco_atual     DECIMAL(12,2)   NOT NULL,
    status_produto  VARCHAR(30)     NOT NULL,
    PRIMARY KEY (id_produto),
    UNIQUE KEY uk_produto_sku (sku)
) ENGINE=InnoDB;

CREATE TABLE FORNECEDOR (
    id_fornecedor   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_fornecedor VARCHAR(200)    NOT NULL,
    PRIMARY KEY (id_fornecedor)
) ENGINE=InnoDB;

-- N:N entre PRODUTO e FORNECEDOR
CREATE TABLE PRODUTO_FORNECEDOR (
    id_produto      BIGINT UNSIGNED NOT NULL,
    id_fornecedor   BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_produto, id_fornecedor),
    KEY idx_prodforn_fornecedor (id_fornecedor),
    CONSTRAINT fk_prodforn_produto
        FOREIGN KEY (id_produto) REFERENCES PRODUTO (id_produto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prodforn_fornecedor
        FOREIGN KEY (id_fornecedor) REFERENCES FORNECEDOR (id_fornecedor)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 5) Itens do pedido
-- =====================================================================
CREATE TABLE ITEM_PEDIDO (
    id_item_pedido           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido                BIGINT UNSIGNED NOT NULL,
    id_produto               BIGINT UNSIGNED NOT NULL,
    quantidade               INT UNSIGNED    NOT NULL,
    preco_unitario_compra    DECIMAL(12,2)   NOT NULL,
    PRIMARY KEY (id_item_pedido),
    KEY idx_ip_pedido (id_pedido),
    KEY idx_ip_produto (id_produto),
    CONSTRAINT fk_ip_pedido
        FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ip_produto
        FOREIGN KEY (id_produto) REFERENCES PRODUTO (id_produto)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 6) Estoque
-- =====================================================================
CREATE TABLE ESTOQUE (
    id_estoque      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome_local      VARCHAR(150)    NOT NULL,
    descricao_local VARCHAR(255),
    PRIMARY KEY (id_estoque)
) ENGINE=InnoDB;

CREATE TABLE PRODUTO_ESTOQUE (
    id_produto      BIGINT UNSIGNED NOT NULL,
    id_estoque      BIGINT UNSIGNED NOT NULL,
    quantidade      INT UNSIGNED    NOT NULL DEFAULT 0,
    PRIMARY KEY (id_produto, id_estoque),
    KEY idx_prodest_estoque (id_estoque),
    CONSTRAINT fk_prodest_produto
        FOREIGN KEY (id_produto) REFERENCES PRODUTO (id_produto)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prodest_estoque
        FOREIGN KEY (id_estoque) REFERENCES ESTOQUE (id_estoque)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- 7) Pagamentos, entregas e devoluções
-- =====================================================================
CREATE TABLE PAGAMENTO (
    id_pagamento         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido            BIGINT UNSIGNED NOT NULL,
    id_forma_pagamento   BIGINT UNSIGNED NOT NULL,
    valor                DECIMAL(12,2)   NOT NULL,
    data_pagamento       DATE            NOT NULL,
    status_pagamento     VARCHAR(30)     NOT NULL,
    PRIMARY KEY (id_pagamento),
    KEY idx_pag_pedido (id_pedido),
    KEY idx_pag_forma (id_forma_pagamento),
    CONSTRAINT fk_pag_pedido
        FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pag_forma
        FOREIGN KEY (id_forma_pagamento) REFERENCES FORMA_PAGAMENTO (id_forma_pagamento)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ENTREGA (
    id_entrega      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido       BIGINT UNSIGNED NOT NULL,
    status_entrega  VARCHAR(30)     NOT NULL,
    codigo_rastreio VARCHAR(100),
    PRIMARY KEY (id_entrega),
    KEY idx_entrega_pedido (id_pedido),
    CONSTRAINT fk_entrega_pedido
        FOREIGN KEY (id_pedido) REFERENCES PEDIDO (id_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE DEVOLUCAO (
    id_devolucao           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_item_pedido         BIGINT UNSIGNED NOT NULL,
    data_solicitacao       DATE            NOT NULL,
    quantidade_solicitada  INT UNSIGNED    NOT NULL,
    status_devolucao       VARCHAR(30)     NOT NULL,
    PRIMARY KEY (id_devolucao),
    KEY idx_dev_item (id_item_pedido),
    CONSTRAINT fk_dev_item
        FOREIGN KEY (id_item_pedido) REFERENCES ITEM_PEDIDO (id_item_pedido)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ESTORNO (
    id_estorno       BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pagamento     BIGINT UNSIGNED NOT NULL,
    data_estorno     DATE            NOT NULL,
    valor_estornado  DECIMAL(12,2)   NOT NULL,
    motivo           VARCHAR(255),
    status_estorno   VARCHAR(30)     NOT NULL,
    PRIMARY KEY (id_estorno),
    KEY idx_estorno_pagamento (id_pagamento),
    CONSTRAINT fk_estorno_pagamento
        FOREIGN KEY (id_pagamento) REFERENCES PAGAMENTO (id_pagamento)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;


DELIMITER $$

CREATE TRIGGER trg_pf_disjunta_bi
BEFORE INSERT ON PESSOA_FISICA
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM PESSOA_JURIDICA WHERE id_cliente = NEW.id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente já classificado como PESSOA_JURIDICA (especialização disjunta).';
    END IF;
END$$

CREATE TRIGGER trg_pj_disjunta_bi
BEFORE INSERT ON PESSOA_JURIDICA
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM PESSOA_FISICA WHERE id_cliente = NEW.id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente já classificado como PESSOA_FISICA (especialização disjunta).';
    END IF;
END$$

DELIMITER ;