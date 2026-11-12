-- Exemplos para executar depois de script.sql em um banco de teste limpo.
-- Em caso de erro, interrompa a execução e execute ROLLBACK na mesma sessão.
USE loja;

-- A procedure participa da transação do chamador: ela não executa COMMIT.
START TRANSACTION;
CALL sp_manipular_produto(
    1, NULL, 'TRANSACAO-COMMIT-001', 'Produto transacional',
    'Exemplo persistido por uma procedure', 100.00, 'ATIVO'
);
UPDATE PRODUTO
SET preco_atual = 120.00
WHERE sku = 'TRANSACAO-COMMIT-001';
SELECT sku, nome, preco_atual FROM PRODUTO
WHERE sku = 'TRANSACAO-COMMIT-001';
COMMIT;

-- Esta consulta, após o COMMIT, deve mostrar o produto com preço 120.00.
SELECT sku, nome, preco_atual FROM PRODUTO
WHERE sku = 'TRANSACAO-COMMIT-001';

-- As duas modificações abaixo são desfeitas pelo ROLLBACK.
START TRANSACTION;
UPDATE PRODUTO
SET preco_atual = 999.00
WHERE sku = 'TRANSACAO-COMMIT-001';
INSERT INTO PRODUTO (sku, nome, descricao, preco_atual, status_produto)
VALUES ('TRANSACAO-ROLLBACK-001', 'Produto revertido',
        'Este produto não deve persistir', 50.00, 'ATIVO');
SELECT sku, nome, preco_atual FROM PRODUTO
WHERE sku IN ('TRANSACAO-COMMIT-001', 'TRANSACAO-ROLLBACK-001')
ORDER BY sku;
ROLLBACK;

-- Deve mostrar somente o produto confirmado, novamente com preço 120.00.
SELECT sku, nome, preco_atual FROM PRODUTO
WHERE sku IN ('TRANSACAO-COMMIT-001', 'TRANSACAO-ROLLBACK-001')
ORDER BY sku;
