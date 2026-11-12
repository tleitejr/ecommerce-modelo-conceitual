-- =====================================================================
-- PARTE A — E-COMMERCE (loja)
-- =====================================================================
CREATE DATABASE IF NOT EXISTS loja
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE loja;

-- ---------- Schema original (inalterado) ----------
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
    CONSTRAINT fk_pf_cliente FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PESSOA_JURIDICA (
    id_cliente     BIGINT UNSIGNED NOT NULL,
    razao_social   VARCHAR(200)    NOT NULL,
    nome_fantasia  VARCHAR(200),
    cnpj           CHAR(14)        NOT NULL,
    PRIMARY KEY (id_cliente),
    UNIQUE KEY uk_pj_cnpj (cnpj),
    CONSTRAINT fk_pj_cliente FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

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
    CONSTRAINT fk_ec_cliente FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE FORMA_PAGAMENTO (
    id_forma_pagamento      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente              BIGINT UNSIGNED NOT NULL,
    tipo_forma_pagamento    VARCHAR(30)     NOT NULL,
    titular                 VARCHAR(150),
    validade                CHAR(7),
    identificador_seguro    VARCHAR(50),
    ultimos_digitos         CHAR(4),
    PRIMARY KEY (id_forma_pagamento),
    KEY idx_fp_cliente (id_cliente),
    CONSTRAINT fk_fp_cliente FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE PEDIDO (
    id_pedido                BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente               BIGINT UNSIGNED NOT NULL,
    data_pedido              DATE            NOT NULL,
    status_pedido            VARCHAR(30)     NOT NULL,
    valor_frete_contratado   DECIMAL(12,2)   NOT NULL DEFAULT 0.00,
    data_limite_devolucao    DATE,
    PRIMARY KEY (id_pedido),
    KEY idx_pedido_cliente (id_cliente),
    CONSTRAINT fk_pedido_cliente FOREIGN KEY (id_cliente)
        REFERENCES CLIENTE (id_cliente) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

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
    CONSTRAINT fk_ee_pedido FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO (id_pedido) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

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

CREATE TABLE PRODUTO_FORNECEDOR (
    id_produto      BIGINT UNSIGNED NOT NULL,
    id_fornecedor   BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_produto, id_fornecedor),
    KEY idx_prodforn_fornecedor (id_fornecedor),
    CONSTRAINT fk_prodforn_produto FOREIGN KEY (id_produto)
        REFERENCES PRODUTO (id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prodforn_fornecedor FOREIGN KEY (id_fornecedor)
        REFERENCES FORNECEDOR (id_fornecedor) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ITEM_PEDIDO (
    id_item_pedido           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido                BIGINT UNSIGNED NOT NULL,
    id_produto               BIGINT UNSIGNED NOT NULL,
    quantidade               INT UNSIGNED    NOT NULL,
    preco_unitario_compra    DECIMAL(12,2)   NOT NULL,
    PRIMARY KEY (id_item_pedido),
    KEY idx_ip_pedido (id_pedido),
    KEY idx_ip_produto (id_produto),
    CONSTRAINT fk_ip_pedido FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO (id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ip_produto FOREIGN KEY (id_produto)
        REFERENCES PRODUTO (id_produto) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

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
    CONSTRAINT fk_prodest_produto FOREIGN KEY (id_produto)
        REFERENCES PRODUTO (id_produto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_prodest_estoque FOREIGN KEY (id_estoque)
        REFERENCES ESTOQUE (id_estoque) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

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
    CONSTRAINT fk_pag_pedido FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO (id_pedido) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pag_forma FOREIGN KEY (id_forma_pagamento)
        REFERENCES FORMA_PAGAMENTO (id_forma_pagamento) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE ENTREGA (
    id_entrega      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_pedido       BIGINT UNSIGNED NOT NULL,
    status_entrega  VARCHAR(30)     NOT NULL,
    codigo_rastreio VARCHAR(100),
    PRIMARY KEY (id_entrega),
    KEY idx_entrega_pedido (id_pedido),
    CONSTRAINT fk_entrega_pedido FOREIGN KEY (id_pedido)
        REFERENCES PEDIDO (id_pedido) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE DEVOLUCAO (
    id_devolucao           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_item_pedido         BIGINT UNSIGNED NOT NULL,
    data_solicitacao       DATE            NOT NULL,
    quantidade_solicitada  INT UNSIGNED    NOT NULL,
    status_devolucao       VARCHAR(30)     NOT NULL,
    PRIMARY KEY (id_devolucao),
    KEY idx_dev_item (id_item_pedido),
    CONSTRAINT fk_dev_item FOREIGN KEY (id_item_pedido)
        REFERENCES ITEM_PEDIDO (id_item_pedido) ON DELETE CASCADE ON UPDATE CASCADE
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
    CONSTRAINT fk_estorno_pagamento FOREIGN KEY (id_pagamento)
        REFERENCES PAGAMENTO (id_pagamento) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Triggers originais (disjunção PF/PJ)
DELIMITER $$
CREATE TRIGGER trg_pf_disjunta_bi
BEFORE INSERT ON PESSOA_FISICA FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM PESSOA_JURIDICA WHERE id_cliente = NEW.id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente já classificado como PESSOA_JURIDICA.';
    END IF;
END$$
CREATE TRIGGER trg_pj_disjunta_bi
BEFORE INSERT ON PESSOA_JURIDICA FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM PESSOA_FISICA WHERE id_cliente = NEW.id_cliente) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cliente já classificado como PESSOA_FISICA.';
    END IF;
END$$
DELIMITER ;

-- =====================================================================
-- PARTE A.1 — ÍNDICES ADICIONAIS (E-commerce)
-- =====================================================================
-- Todos em BTREE (padrão InnoDB). NÃO usamos HASH: InnoDB não suporta
-- índice hash explícito; ele já usa adaptive hash internamente.
-- ---------------------------------------------------------------------

-- 1) PEDIDO: consultas filtram por status e período (dashboards)
--    WHERE status_pedido = ? AND data_pedido >= ?
--    Grupo (status, data) permite range scan eficiente.
CREATE INDEX idx_pedido_status_data
    ON PEDIDO (status_pedido, data_pedido) USING BTREE;

-- 2) PAGAMENTO: conciliação financeira por status e mês
--    WHERE status_pagamento = ? AND data_pagamento BETWEEN ? AND ?
CREATE INDEX idx_pagamento_status_data
    ON PAGAMENTO (status_pagamento, data_pagamento) USING BTREE;

-- 3) PRODUTO: filtragem de catálogo por status + faixa de preço
--    WHERE status_produto = ? AND preco_atual BETWEEN ? AND ?
CREATE INDEX idx_produto_status_preco
    ON PRODUTO (status_produto, preco_atual) USING BTREE;

-- 4) CLIENTE: relatório de novos clientes por período
--    WHERE data_cadastro >= ? (range scan puro)
CREATE INDEX idx_cliente_data_cadastro
    ON CLIENTE (data_cadastro) USING BTREE;

-- 5) ENTREGA: monitoramento logístico por status
--    WHERE status_entrega = ?
CREATE INDEX idx_entrega_status
    ON ENTREGA (status_entrega) USING BTREE;

-- 6) DEVOLUCAO: gestão de devoluções por status e data
--    WHERE status_devolucao = ? AND data_solicitacao >= ?
CREATE INDEX idx_devolucao_status_data
    ON DEVOLUCAO (status_devolucao, data_solicitacao) USING BTREE;

-- 7) ESTORNO: fila de estornos pendentes
--    WHERE status_estorno = ? (e relatórios por data)
CREATE INDEX idx_estorno_status_data
    ON ESTORNO (status_estorno, data_estorno) USING BTREE;

-- 8) PRODUTO (FULLTEXT): busca textual por nome/descrição.
--    LIKE '%termo%' seria full scan; MATCH ... AGAINST usa índice
--    invertido (inverted index) do FULLTEXT.
CREATE FULLTEXT INDEX ft_produto_nome_desc
    ON PRODUTO (nome, descricao);

-- =====================================================================
-- PARTE A.2 — QUERIES (E-commerce) — justificam cada índice
-- =====================================================================

-- Q1: Pedidos pendentes do último mês  --> idx_pedido_status_data
SELECT id_pedido, data_pedido, status_pedido
FROM PEDIDO
WHERE status_pedido = 'PENDENTE'
  AND data_pedido >= DATE_SUB(CURDATE(), INTERVAL 30 DAY);

-- Q2: Total pago por mês (conciliacão) --> idx_pagamento_status_data
SELECT DATE_FORMAT(data_pagamento, '%Y-%m') AS mes,
       SUM(valor)                           AS total
FROM PAGAMENTO
WHERE status_pagamento = 'APROVADO'
GROUP BY mes
ORDER BY mes;

-- Q3: Produtos ativos em faixa de preço --> idx_produto_status_preco
SELECT id_produto, sku, nome, preco_atual
FROM PRODUTO
WHERE status_produto = 'ATIVO'
  AND preco_atual BETWEEN 50.00 AND 500.00
ORDER BY preco_atual;

-- Q4: Novos clientes por mês --> idx_cliente_data_cadastro
SELECT DATE_FORMAT(data_cadastro, '%Y-%m') AS mes,
       COUNT(*)                            AS qtd
FROM CLIENTE
GROUP BY mes
ORDER BY mes;

-- Q5: Entregas em trânsito --> idx_entrega_status
SELECT id_entrega, id_pedido, codigo_rastreio
FROM ENTREGA
WHERE status_entrega = 'EM_TRANSITO';

-- Q6: Devoluções abertas nos últimos 7 dias --> idx_devolucao_status_data
SELECT id_devolucao, id_item_pedido, data_solicitacao
FROM DEVOLUCAO
WHERE status_devolucao = 'SOLICITADA'
  AND data_solicitacao >= DATE_SUB(CURDATE(), INTERVAL 7 DAY);

-- Q7: Estornos pendentes --> idx_estorno_status_data
SELECT id_estorno, id_pagamento, valor_estornado
FROM ESTORNO
WHERE status_estorno = 'PENDENTE';

-- Q8: Busca textual por produto --> ft_produto_nome_desc
SELECT id_produto, sku, nome
FROM PRODUTO
WHERE MATCH(nome, descricao) AGAINST ('notebook' IN NATURAL LANGUAGE MODE);

-- =====================================================================
-- PARTE A.3 — PROCEDURE (E-commerce) com variável de controle
-- =====================================================================
-- Ações:  1 = INSERT | 2 = UPDATE | 3 = DELETE | 4 = SELECT
-- Qualquer outro valor dispara SIGNAL; o chamador deve tratar a transação.
-- =====================================================================
DROP PROCEDURE IF EXISTS sp_manipular_produto;

DELIMITER $$
CREATE PROCEDURE sp_manipular_produto(
    IN p_acao            INT,              -- variável de controle
    IN p_id_produto      BIGINT UNSIGNED,  -- usado em UPDATE/DELETE/SELECT
    IN p_sku             VARCHAR(50),
    IN p_nome            VARCHAR(200),
    IN p_descricao       TEXT,
    IN p_preco_atual     DECIMAL(12,2),
    IN p_status_produto  VARCHAR(30)
)
BEGIN
    CASE p_acao
        WHEN 1 THEN
            INSERT INTO PRODUTO (sku, nome, descricao, preco_atual, status_produto)
            VALUES (p_sku, p_nome, p_descricao, p_preco_atual, p_status_produto);
            SELECT LAST_INSERT_ID() AS id_gerado, 'PRODUTO inserido' AS msg;

        WHEN 2 THEN
            UPDATE PRODUTO
               SET sku            = COALESCE(p_sku,            sku),
                   nome           = COALESCE(p_nome,           nome),
                   descricao      = COALESCE(p_descricao,      descricao),
                   preco_atual    = COALESCE(p_preco_atual,    preco_atual),
                   status_produto = COALESCE(p_status_produto, status_produto)
             WHERE id_produto = p_id_produto;
            SELECT ROW_COUNT() AS linhas_afetadas, 'PRODUTO atualizado' AS msg;

        WHEN 3 THEN
            DELETE FROM PRODUTO WHERE id_produto = p_id_produto;
            SELECT ROW_COUNT() AS linhas_afetadas, 'PRODUTO removido' AS msg;

        WHEN 4 THEN
            SELECT * FROM PRODUTO WHERE id_produto = p_id_produto;

        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT =
                'Ação inválida. Use 1=INSERT, 2=UPDATE, 3=DELETE, 4=SELECT.';
    END CASE;
END$$
DELIMITER ;

-- ---------- Chamadas de exemplo (E-commerce) ----------
CALL sp_manipular_produto(1, NULL, 'SKU-1001', 'Notebook X', 'Notebook 16GB',  3500.00, 'ATIVO');
CALL sp_manipular_produto(1, NULL, 'SKU-1002', 'Mouse Y',    'Mouse óptico',     79.90, 'ATIVO');
CALL sp_manipular_produto(2, 1,   NULL,       'Notebook X Pro', NULL,          3999.90, NULL);
CALL sp_manipular_produto(4, 1,   NULL,       NULL,           NULL,           NULL,    NULL);
CALL sp_manipular_produto(3, 2,   NULL,       NULL,           NULL,           NULL,    NULL);


-- =====================================================================
-- PARTE B — COMPANY / UNIVERSIDADE
-- =====================================================================
CREATE DATABASE IF NOT EXISTS universidade
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE universidade;

-- ---------- Tabelas ----------
CREATE TABLE CIDADE (
    id_cidade  BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome       VARCHAR(150)    NOT NULL,
    uf         CHAR(2)         NOT NULL,
    PRIMARY KEY (id_cidade)
) ENGINE=InnoDB;

CREATE TABLE DEPARTAMENTO (
    id_departamento BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(150)    NOT NULL,
    id_cidade       BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_departamento),
    CONSTRAINT fk_dept_cidade FOREIGN KEY (id_cidade)
        REFERENCES CIDADE (id_cidade) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE EMPREGADO (
    id_empregado     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome             VARCHAR(200)    NOT NULL,
    cpf              CHAR(11)        NOT NULL,
    salario          DECIMAL(12,2)   NOT NULL,
    data_admissao    DATE            NOT NULL,
    id_departamento  BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_empregado),
    UNIQUE KEY uk_emp_cpf (cpf),
    CONSTRAINT fk_emp_dept FOREIGN KEY (id_departamento)
        REFERENCES DEPARTAMENTO (id_departamento)
        ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =====================================================================
-- PARTE B.1 — ÍNDICES (Company / Universidade)
-- =====================================================================
-- Justificativa (todos BTREE, InnoDB):

-- 1) EMPREGADO.id_departamento:
--    usado em GROUP BY / JOIN para "departamento com mais pessoas"
--    e "empregados por departamento". FK sozinha NÃO cria índice
--    no InnoDB (só gera constraint); criamos explicitamente.
CREATE INDEX idx_emp_departamento
    ON EMPREGADO (id_departamento) USING BTREE;

-- 2) DEPARTAMENTO.id_cidade:
--    usado no JOIN para "departamentos por cidade".
CREATE INDEX idx_dept_cidade
    ON DEPARTAMENTO (id_cidade) USING BTREE;

-- 3) EMPREGADO.nome: buscas e ordenações alfabéticas frequentes.
CREATE INDEX idx_emp_nome
    ON EMPREGADO (nome) USING BTREE;

-- 4) CIDADE.nome: filtros por cidade e ordenação em relatórios.
CREATE INDEX idx_cidade_nome
    ON CIDADE (nome) USING BTREE;

-- =====================================================================
-- PARTE B.2 — QUERIES (Company / Universidade)
-- =====================================================================

-- Q1: Departamento com maior número de pessoas
--     Usa idx_emp_departamento (GROUP BY + JOIN)
SELECT d.id_departamento,
       d.nome,
       COUNT(e.id_empregado) AS total_empregados
FROM DEPARTAMENTO d
LEFT JOIN EMPREGADO e ON e.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nome
ORDER BY total_empregados DESC
LIMIT 1;

-- Q2: Departamentos por cidade
--     Usa idx_dept_cidade e idx_cidade_nome
SELECT c.nome AS cidade,
       c.uf,
       d.nome AS departamento
FROM CIDADE c
INNER JOIN DEPARTAMENTO d ON d.id_cidade = c.id_cidade
ORDER BY c.nome, d.nome;

-- Q3: Relação de empregados por departamento
--     Usa idx_emp_departamento (JOIN) + idx_emp_nome (ORDER BY)
SELECT d.nome AS departamento,
       e.nome AS empregado
FROM DEPARTAMENTO d
INNER JOIN EMPREGADO e ON e.id_departamento = d.id_departamento
ORDER BY d.nome, e.nome;

-- =====================================================================
-- PARTE B.3 — PROCEDURE (Company / Universidade)
-- =====================================================================
DROP PROCEDURE IF EXISTS sp_manipular_empregado;

DELIMITER $$
CREATE PROCEDURE sp_manipular_empregado(
    IN p_acao             INT,              -- variável de controle
    IN p_id_empregado     BIGINT UNSIGNED,  -- UPDATE/DELETE/SELECT
    IN p_nome             VARCHAR(200),
    IN p_cpf              CHAR(11),
    IN p_salario          DECIMAL(12,2),
    IN p_data_admissao    DATE,
    IN p_id_departamento  BIGINT UNSIGNED
)
BEGIN
    CASE p_acao
        WHEN 1 THEN
            INSERT INTO EMPREGADO (nome, cpf, salario, data_admissao, id_departamento)
            VALUES (p_nome, p_cpf, p_salario, p_data_admissao, p_id_departamento);
            SELECT LAST_INSERT_ID() AS id_gerado, 'EMPREGADO inserido' AS msg;

        WHEN 2 THEN
            UPDATE EMPREGADO
               SET nome            = COALESCE(p_nome,            nome),
                   cpf             = COALESCE(p_cpf,             cpf),
                   salario         = COALESCE(p_salario,         salario),
                   data_admissao   = COALESCE(p_data_admissao,   data_admissao),
                   id_departamento = COALESCE(p_id_departamento, id_departamento)
             WHERE id_empregado = p_id_empregado;
            SELECT ROW_COUNT() AS linhas_afetadas, 'EMPREGADO atualizado' AS msg;

        WHEN 3 THEN
            DELETE FROM EMPREGADO WHERE id_empregado = p_id_empregado;
            SELECT ROW_COUNT() AS linhas_afetadas, 'EMPREGADO removido' AS msg;

        WHEN 4 THEN
            SELECT * FROM EMPREGADO WHERE id_empregado = p_id_empregado;

        ELSE
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT =
                'Ação inválida. Use 1=INSERT, 2=UPDATE, 3=DELETE, 4=SELECT.';
    END CASE;
END$$
DELIMITER ;

-- ---------- Carga inicial e chamadas de exemplo (Universidade) ----------
INSERT INTO CIDADE (nome, uf) VALUES
    ('São Paulo',      'SP'),
    ('Rio de Janeiro', 'RJ'),
    ('Belo Horizonte', 'MG');

INSERT INTO DEPARTAMENTO (nome, id_cidade) VALUES
    ('Tecnologia', 1),
    ('Recursos Humanos', 2),
    ('Financeiro', 1),
    ('Comercial', 3);

CALL sp_manipular_empregado(1, NULL, 'João Silva',    '11111111111', 5000.00, '2023-01-15', 1);
CALL sp_manipular_empregado(1, NULL, 'Maria Souza',   '22222222222', 6200.00, '2022-08-10', 1);
CALL sp_manipular_empregado(1, NULL, 'Pedro Santos',  '33333333333', 4500.00, '2024-03-01', 2);
CALL sp_manipular_empregado(1, NULL, 'Ana Oliveira',  '44444444444', 7800.00, '2021-05-20', 3);

CALL sp_manipular_empregado(2, 3, 'Pedro S. Santos',  NULL, 4800.00, NULL, NULL);
CALL sp_manipular_empregado(4, 3, NULL, NULL, NULL, NULL, NULL);
CALL sp_manipular_empregado(3, 3, NULL, NULL, NULL, NULL, NULL);

-- =====================================================================
-- PARTE C — EXTENSÕES NO SCHEMA universidade
-- (necessárias para viabilizar as views da Parte 1)
-- =====================================================================
USE universidade;

-- C.1) Gerente do departamento (auto-relacionamento DEPARTAMENTO ↔ EMPREGADO)
ALTER TABLE DEPARTAMENTO
    ADD COLUMN id_gerente BIGINT UNSIGNED NULL,
    ADD CONSTRAINT fk_dept_gerente FOREIGN KEY (id_gerente)
        REFERENCES EMPREGADO (id_empregado)
        ON DELETE SET NULL ON UPDATE CASCADE;

-- C.2) Projetos (cada projeto pertence a um departamento)
CREATE TABLE PROJETO (
    id_projeto      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    nome            VARCHAR(200)    NOT NULL,
    id_departamento BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (id_projeto),
    KEY idx_projeto_dept (id_departamento),
    CONSTRAINT fk_projeto_dept FOREIGN KEY (id_departamento)
        REFERENCES DEPARTAMENTO (id_departamento)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- C.3) Alocação N:N de empregados em projetos
CREATE TABLE PROJETO_EMPREGADO (
    id_projeto      BIGINT UNSIGNED NOT NULL,
    id_empregado    BIGINT UNSIGNED NOT NULL,
    horas_alocadas  INT UNSIGNED    NOT NULL DEFAULT 0,
    PRIMARY KEY (id_projeto, id_empregado),
    KEY idx_pe_empregado (id_empregado),
    CONSTRAINT fk_pe_projeto FOREIGN KEY (id_projeto)
        REFERENCES PROJETO (id_projeto) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pe_empregado FOREIGN KEY (id_empregado)
        REFERENCES EMPREGADO (id_empregado) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- C.4) Dependentes de empregados
CREATE TABLE DEPENDENTE (
    id_dependente   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_empregado    BIGINT UNSIGNED NOT NULL,
    nome            VARCHAR(200)    NOT NULL,
    parentesco      VARCHAR(50),
    data_nascimento DATE,
    PRIMARY KEY (id_dependente),
    KEY idx_dep_empregado (id_empregado),
    CONSTRAINT fk_dep_empregado FOREIGN KEY (id_empregado)
        REFERENCES EMPREGADO (id_empregado) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- C.5) Histórico de salários (log para triggers da Parte 2)
CREATE TABLE HISTORICO_SALARIO (
    id_historico     BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_empregado     BIGINT UNSIGNED NOT NULL,
    nome_empregado   VARCHAR(200),
    salario_anterior DECIMAL(12,2),
    salario_novo     DECIMAL(12,2),
    tipo_evento      ENUM('INSERT','UPDATE') NOT NULL,
    data_evento      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_historico),
    KEY idx_hist_empregado (id_empregado)
) ENGINE=InnoDB;

-- C.6) Carga complementar de dados para as views
--      (IDs dos empregados já existentes: 1=João, 2=Maria, 4=Ana)
INSERT INTO EMPREGADO (nome, cpf, salario, data_admissao, id_departamento) VALUES
    ('Carlos Pereira', '55555555555', 5500.00, '2020-07-01', 1),   -- id 5
    ('Beatriz Lima',   '66666666666', 4900.00, '2022-11-15', 2),   -- id 6
    ('Diego Alves',    '77777777777', 7000.00, '2019-02-10', 3),   -- id 7
    ('Eduarda Rocha',  '88888888888', 8100.00, '2021-10-05', 4);   -- id 8

UPDATE DEPARTAMENTO SET id_gerente = 2 WHERE id_departamento = 1;  -- Tecnologia  → Maria
UPDATE DEPARTAMENTO SET id_gerente = 6 WHERE id_departamento = 2;  -- RH          → Beatriz
UPDATE DEPARTAMENTO SET id_gerente = 4 WHERE id_departamento = 3;  -- Financeiro  → Ana
UPDATE DEPARTAMENTO SET id_gerente = 8 WHERE id_departamento = 4;  -- Comercial   → Eduarda

INSERT INTO PROJETO (nome, id_departamento) VALUES
    ('Migração ERP',        1),
    ('Portal do Cliente',   1),
    ('Reestruturação RH',   2),
    ('Auditoria 2024',      3),
    ('Campanha Vendas Q1',  4);

INSERT INTO PROJETO_EMPREGADO (id_projeto, id_empregado, horas_alocadas) VALUES
    (1, 1, 100), (1, 2,  80), (1, 5,  50),
    (2, 1,  60), (2, 5,  40),
    (3, 6, 120),
    (4, 4, 200), (4, 7,  90),
    (5, 8, 150), (5, 7,  40);

INSERT INTO DEPENDENTE (id_empregado, nome, parentesco, data_nascimento) VALUES
    (1, 'Lucas Silva',   'Filho',   '2015-06-01'),
    (1, 'Carla Silva',   'Cônjuge', '1985-02-14'),
    (2, 'Mariana Souza', 'Filha',   '2018-11-20'),
    (4, 'Rosa Oliveira', 'Mãe',     '1950-03-10'),
    (5, 'Pedro Pereira', 'Filho',   '2010-09-25'),
    (8, 'Tiago Rocha',   'Filho',   '2012-04-18');


-- =====================================================================
-- PARTE D — VIEWS (Parte 1: Personalizando acessos com views)
-- =====================================================================
USE universidade;

-- D.1) Número de empregados por departamento e localidade
CREATE OR REPLACE VIEW vw_empregados_por_departamento_localidade AS
SELECT d.id_departamento,
       d.nome                AS departamento,
       c.nome                AS cidade,
       c.uf,
       COUNT(e.id_empregado) AS total_empregados
FROM DEPARTAMENTO d
INNER JOIN CIDADE c   ON c.id_cidade       = d.id_cidade
LEFT  JOIN EMPREGADO e ON e.id_departamento = d.id_departamento
GROUP BY d.id_departamento, d.nome, c.nome, c.uf;

-- D.2) Lista de departamentos e seus gerentes
CREATE OR REPLACE VIEW vw_departamentos_gerentes AS
SELECT d.id_departamento,
       d.nome             AS departamento,
       c.nome             AS cidade,
       c.uf,
       g.id_empregado     AS id_gerente,
       g.nome             AS gerente
FROM DEPARTAMENTO d
INNER JOIN CIDADE c   ON c.id_cidade     = d.id_cidade
LEFT  JOIN EMPREGADO g ON g.id_empregado = d.id_gerente;

-- D.3) Projetos com maior número de empregados (ordenação desc)
CREATE OR REPLACE VIEW vw_projetos_mais_empregados AS
SELECT p.id_projeto,
       p.nome                 AS projeto,
       d.nome                 AS departamento,
       COUNT(pe.id_empregado) AS total_empregados
FROM PROJETO p
INNER JOIN DEPARTAMENTO d       ON d.id_departamento = p.id_departamento
LEFT  JOIN PROJETO_EMPREGADO pe ON pe.id_projeto      = p.id_projeto
GROUP BY p.id_projeto, p.nome, d.nome
ORDER BY total_empregados DESC;

-- D.4) Lista de projetos, departamentos e gerentes
CREATE OR REPLACE VIEW vw_projetos_departamentos_gerentes AS
SELECT p.id_projeto,
       p.nome      AS projeto,
       d.nome      AS departamento,
       c.nome      AS cidade,
       c.uf,
       g.nome      AS gerente
FROM PROJETO p
INNER JOIN DEPARTAMENTO d ON d.id_departamento = p.id_departamento
INNER JOIN CIDADE c       ON c.id_cidade        = d.id_cidade
LEFT  JOIN EMPREGADO g    ON g.id_empregado     = d.id_gerente;

-- D.5) Quais empregados possuem dependentes e se são gerentes
CREATE OR REPLACE VIEW vw_empregados_dependentes_gerentes AS
SELECT e.id_empregado,
       e.nome           AS empregado,
       (SELECT COUNT(*)
          FROM DEPENDENTE dep
         WHERE dep.id_empregado = e.id_empregado)                       AS qtd_dependentes,
       CASE WHEN EXISTS (SELECT 1
                          FROM DEPARTAMENTO d
                         WHERE d.id_gerente = e.id_empregado)
            THEN 'SIM' ELSE 'NÃO' END                                    AS eh_gerente
FROM EMPREGADO e;

-- D.5b) Versão reduzida (SEM departamento / gerente) → usada pelo EMPREGADO
CREATE OR REPLACE VIEW vw_empregados_dependentes AS
SELECT e.id_empregado,
       e.nome           AS empregado,
       (SELECT COUNT(*)
          FROM DEPENDENTE dep
         WHERE dep.id_empregado = e.id_empregado) AS qtd_dependentes
FROM EMPREGADO e;


-- =====================================================================
-- PARTE E — PERMISSÕES DE ACESSO ÀS VIEWS
-- =====================================================================
USE universidade;

-- Contas de usuário (troque as senhas antes de produção!)
CREATE USER IF NOT EXISTS 'gerente_user'@'localhost'   IDENTIFIED BY 'Gerente@2024';
CREATE USER IF NOT EXISTS 'empregado_user'@'localhost' IDENTIFIED BY 'Empregado@2024';

-- GERENTE: acesso a TODAS as views (contém dados de depto/gerente/projetos)
GRANT SELECT ON universidade.vw_empregados_por_departamento_localidade TO 'gerente_user'@'localhost';
GRANT SELECT ON universidade.vw_departamentos_gerentes                TO 'gerente_user'@'localhost';
GRANT SELECT ON universidade.vw_projetos_mais_empregados              TO 'gerente_user'@'localhost';
GRANT SELECT ON universidade.vw_projetos_departamentos_gerentes       TO 'gerente_user'@'localhost';
GRANT SELECT ON universidade.vw_empregados_dependentes_gerentes       TO 'gerente_user'@'localhost';

-- EMPREGADO: acesso SOMENTE à view reduzida (sem depto e sem gerente)
GRANT SELECT ON universidade.vw_empregados_dependentes                TO 'empregado_user'@'localhost';

FLUSH PRIVILEGES;


-- =====================================================================
-- PARTE F — TRIGGERS DE E-COMMERCE (Parte 2)
-- =====================================================================
USE loja;

-- F.1) Tabela de auditoria dos clientes excluídos
CREATE TABLE CLIENTE_EXCLUIDO (
    id_exclusao         BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_cliente_original BIGINT UNSIGNED NOT NULL,
    email               VARCHAR(255),
    telefone            VARCHAR(20),
    data_cadastro       DATE,
    tipo_pessoa         ENUM('PF','PJ','NAO_CLASSIFICADO') NOT NULL DEFAULT 'NAO_CLASSIFICADO',
    nome_completo       VARCHAR(200),
    cpf                 CHAR(11),
    razao_social        VARCHAR(200),
    nome_fantasia       VARCHAR(200),
    cnpj                CHAR(14),
    data_exclusao       DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_exclusao),
    KEY idx_ce_cliente (id_cliente_original)
) ENGINE=InnoDB;

-- F.2) BEFORE DELETE em CLIENTE
--      Copia dados do cliente + dados de PF/PJ antes do CASCADE remover tudo.
DROP TRIGGER IF EXISTS trg_cliente_before_delete;
DELIMITER $$
CREATE TRIGGER trg_cliente_before_delete
BEFORE DELETE ON CLIENTE FOR EACH ROW
BEGIN
    DECLARE v_tipo     VARCHAR(20)  DEFAULT 'NAO_CLASSIFICADO';
    DECLARE v_nome     VARCHAR(200) DEFAULT NULL;
    DECLARE v_cpf      CHAR(11)     DEFAULT NULL;
    DECLARE v_razao    VARCHAR(200) DEFAULT NULL;
    DECLARE v_fantasia VARCHAR(200) DEFAULT NULL;
    DECLARE v_cnpj     CHAR(14)     DEFAULT NULL;

    IF EXISTS (SELECT 1 FROM PESSOA_FISICA WHERE id_cliente = OLD.id_cliente) THEN
        SELECT nome_completo, cpf
          INTO v_nome, v_cpf
          FROM PESSOA_FISICA
         WHERE id_cliente = OLD.id_cliente;
        SET v_tipo = 'PF';

    ELSEIF EXISTS (SELECT 1 FROM PESSOA_JURIDICA WHERE id_cliente = OLD.id_cliente) THEN
        SELECT razao_social, nome_fantasia, cnpj
          INTO v_razao, v_fantasia, v_cnpj
          FROM PESSOA_JURIDICA
         WHERE id_cliente = OLD.id_cliente;
        SET v_tipo = 'PJ';
    END IF;

    INSERT INTO CLIENTE_EXCLUIDO
        (id_cliente_original, email, telefone, data_cadastro,
         tipo_pessoa, nome_completo, cpf, razao_social, nome_fantasia, cnpj)
    VALUES
        (OLD.id_cliente, OLD.email, OLD.telefone, OLD.data_cadastro,
         v_tipo, v_nome, v_cpf, v_razao, v_fantasia, v_cnpj);
END$$
DELIMITER ;


-- =====================================================================
-- PARTE G — TRIGGERS DE COLABORADORES (universidade)
--   "Inserção de novos colaboradores e atualização do salário base"
-- =====================================================================
USE universidade;

-- G.1) BEFORE INSERT — valida salário e registra a contratação
DROP TRIGGER IF EXISTS trg_empregado_before_insert;
DELIMITER $$
CREATE TRIGGER trg_empregado_before_insert
BEFORE INSERT ON EMPREGADO FOR EACH ROW
BEGIN
    IF NEW.salario IS NULL OR NEW.salario <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salário base deve ser maior que zero.';
    END IF;
END$$
DELIMITER ;

-- G.2) AFTER INSERT — grava o evento de contratação
DROP TRIGGER IF EXISTS trg_empregado_after_insert;
DELIMITER $$
CREATE TRIGGER trg_empregado_after_insert
AFTER INSERT ON EMPREGADO FOR EACH ROW
BEGIN
    INSERT INTO HISTORICO_SALARIO
        (id_empregado, nome_empregado, salario_anterior, salario_novo, tipo_evento)
    VALUES
        (NEW.id_empregado, NEW.nome, NULL, NEW.salario, 'INSERT');
END$$
DELIMITER ;

-- G.3) BEFORE UPDATE — valida e registra alteração de salário
DROP TRIGGER IF EXISTS trg_empregado_before_update;
DELIMITER $$
CREATE TRIGGER trg_empregado_before_update
BEFORE UPDATE ON EMPREGADO FOR EACH ROW
BEGIN
    IF NEW.salario IS NULL OR NEW.salario <= 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Salário base deve ser maior que zero.';
    END IF;

    IF NEW.salario <> OLD.salario THEN
        INSERT INTO HISTORICO_SALARIO
            (id_empregado, nome_empregado, salario_anterior, salario_novo, tipo_evento)
        VALUES
            (OLD.id_empregado, OLD.nome, OLD.salario, NEW.salario, 'UPDATE');
    END IF;
END$$
DELIMITER ;


-- =====================================================================
-- PARTE H — TESTES RÁPIDOS (opcional)
-- =====================================================================
-- ---------- Views (universidade) ----------
SELECT * FROM vw_empregados_por_departamento_localidade;
SELECT * FROM vw_departamentos_gerentes;
SELECT * FROM vw_projetos_mais_empregados;
SELECT * FROM vw_projetos_departamentos_gerentes;
SELECT * FROM vw_empregados_dependentes_gerentes;
SELECT * FROM vw_empregados_dependentes;

-- ---------- Trigger BEFORE DELETE (loja) ----------
USE loja;
INSERT INTO CLIENTE (email, telefone, data_cadastro)
     VALUES ('teste.exclusao@exemplo.com', '11999999999', CURDATE());
INSERT INTO PESSOA_FISICA (id_cliente, nome_completo, cpf)
     VALUES (LAST_INSERT_ID(), 'Cliente Excluído Teste', '99988877766');
DELETE FROM CLIENTE WHERE email = 'teste.exclusao@exemplo.com';
SELECT * FROM CLIENTE_EXCLUIDO;

-- ---------- Triggers de colaboradores (universidade) ----------
USE universidade;
UPDATE EMPREGADO SET salario = 5500.00 WHERE id_empregado = 1;
SELECT * FROM HISTORICO_SALARIO ORDER BY id_historico;