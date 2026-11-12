# E-commerce — Modelo Conceitual de Banco de Dados

## 1. Descrição do projeto

Este projeto apresenta um modelo conceitual de banco de dados para uma plataforma de comércio eletrônico que vende seus próprios produtos.

O objetivo é representar os principais elementos do negócio:

- clientes;
- pedidos;
- produtos;
- fornecedores;
- estoque;
- formas de pagamento;
- pagamentos;
- entregas;
- frete;
- devoluções.

O projeto utiliza o modelo Entidade-Relacionamento (ER), com entidades, atributos, relacionamentos, cardinalidades e restrições conceituais.

O projeto também contém um script MySQL executável, exemplos de transações e
backups de dados demonstrativos. Não há código de aplicação.

## 2. Contexto do esquema

A plataforma comercializa produtos próprios, sem vendedores terceiros no escopo inicial.

O modelo contempla:

- Clientes classificados como Pessoa Física ou Pessoa Jurídica.
- Cadastro de vários endereços por cliente.
- Registro de pedidos e respectivos itens.
- Preservação do preço unitário praticado na compra.
- Fornecedores associados aos produtos.
- Estoque distribuído em locais distintos.
- Cadastro de várias formas de pagamento por cliente.
- Registro de pagamentos e possíveis estornos.
- Entregas com status e código de rastreio.
- Devoluções vinculadas aos itens dos pedidos.

O endereço de entrega e o valor do frete são preservados no pedido para que alterações posteriores nos cadastros não modifiquem o histórico da compra.

## 3. Regras de modelagem adotadas

### 3.1 Clientes

A entidade Cliente possui especialização total e disjunta:

- Todo cliente deve ser Pessoa Física ou Pessoa Jurídica.
- Uma mesma conta não pode pertencer aos dois subtipos.
- Pessoa Física possui CPF.
- Pessoa Jurídica possui CNPJ.

### 3.2 Pedidos e itens

Um cliente pode realizar vários pedidos.

Todo pedido deve possuir pelo menos um item. A entidade associativa
ItemPedido registra:

- Produto comprado.
- Quantidade.
- Preço unitário no momento da compra.

O preço histórico não depende do preço atual do produto.

### 3.3 Endereço e frete

O pedido possui um endereço de entrega histórico, independente dos endereços atualmente cadastrados pelo cliente.

O valor do frete contratado fica registrado no pedido e deve ser preservado em caso de cancelamento ou estorno.

A política de restituição do frete ainda precisa ser confirmada.

### 3.4 Pagamentos

Um cliente pode cadastrar várias formas de pagamento.

A entidade FormaPagamento é separada da entidade Pagamento:
uma representa o meio cadastrado; a outra representa uma cobrança.

Não armazenar CVV ou código de segurança do cartão.

Para cartões, recomenda-se utilizar tokenização ou identificador seguro fornecido pelo processador de pagamentos, em vez de armazenar o número completo do cartão.

### 3.5 Entregas

A entidade Entrega registra status e código de rastreio.

O status do pedido é diferente do status da entrega:

- Status do pedido: situação comercial da compra.
- Status da entrega: situação logística da remessa.

### 3.6 Estoque

A entidade associativa ProdutoEstoque registra a quantidade de um produto em determinado local de armazenamento.

### 3.7 Devoluções

A devolução é opcional e está associada ao item do pedido. O modelo admite devoluções parciais de quantidade.

A solicitação deve respeitar o prazo de devolução registrado no pedido.

## 4. Decisões provisórias e ambiguidades pendentes

As escolhas abaixo são premissas de modelagem, não regras confirmadas do negócio.

| Tema | Premissa adotada | Confirmação pendente |
|---|---|---|
| Fornecedor por produto | Relação N:N. Cada produto possui ao menos um fornecedor e pode ter vários. | Confirmar se um produto pode ter apenas um fornecedor. |
| Entregas por pedido | Um pedido pode gerar zero ou várias entregas. | Confirmar se haverá divisão de pedidos em remessas. |
| Pagamento dividido | Um pedido pode receber vários registros de pagamento, cada um usando uma forma. | Confirmar se um pedido pode ser pago com mais de um meio. |
| Devolução | Devolução vinculada ao item, permitindo devolução parcial. | Confirmar se a operação também precisa de devolução integral do pedido como uma única solicitação. |
| Estoque em vários locais | O modelo permite vários locais para o mesmo produto. | Confirmar se múltiplos locais são obrigatórios no escopo inicial. |
| Outros meios de pagamento | A entidade possui um tipo e um identificador seguro genérico. | Definir atributos específicos para métodos além de cartão. |
| Prazo de devolução | O pedido registra uma data limite. | Definir a regra de cálculo do prazo e suas exceções. |
| Estornos | Estorno é registrado por pagamento. | Definir regras de restituição de frete e de estornos parciais. |

### 4.1 Premissas adicionais

- Fornecedores representam empresas ou pessoas que abastecem a loja, não vendedores terceiros da plataforma.
- Cada pedido possui um único endereço de entrega histórico.
- A forma de pagamento utilizada deve pertencer ao cliente responsável pelo pedido.
- Cada ocorrência de Pagamento utiliza exatamente uma forma de pagamento.
- O código de rastreio pode ficar pendente até a transportadora disponibilizá-lo.
- A soma das quantidades devolvidas de um item não pode exceder a quantidade comprada.
- A entidade Estorno é complementar e poderá ser ajustada caso o negócio não precise registrar cada estorno individualmente.

## 5. Arquivos do projeto

    ecommerce-modelo-conceitual/
    ├── README.md
    ├── script.sql
    ├── transacoes.sql
    ├── backups/
    │   ├── loja.sql
    │   └── loja-universidade.sql
    ├── diagrama.mmd
    └── exportacoes/
        ├── diagrama.png
        └── diagrama.pdf

- `script.sql`: cria e popula os bancos `loja` e `universidade`, incluindo
  procedures, views e triggers de exemplo.
- `transacoes.sql`: demonstra consultas e alterações com commit e rollback,
  incluindo uma chamada de procedure em uma transação.
- `backups/loja.sql`: dump restaurável do banco de e-commerce.
- `backups/loja-universidade.sql`: dump restaurável dos dois bancos.
- `diagrama.mmd`: código-fonte do diagrama Mermaid.
- `exportacoes/diagrama.png`: imagem exportada.
- `exportacoes/diagrama.pdf`: versão em PDF.

## 6. Execução dos scripts

Os exemplos foram validados com MySQL 8.0 e usam tabelas InnoDB. Execute os
comandos abaixo a partir da raiz do projeto, em uma instância **isolada e
vazia**, usando uma conta com privilégios suficientes:

```sh
mysql --login-path=teste --default-character-set=utf8mb4 < script.sql
mysql --login-path=teste --default-character-set=utf8mb4 < transacoes.sql
```

Configure previamente o perfil `teste` com `mysql_config_editor set
--login-path=teste --host=HOST --user=USUARIO --password`; informe a senha
interativamente e substitua `HOST` e `USUARIO` pelos valores apropriados. O
arquivo de login é ofuscado, não é um cofre: proteja suas permissões. Os
comandos pressupõem os utilitários de cliente MySQL disponíveis; também é
possível executá-los dentro de um contêiner MySQL 8.

`script.sql` não é idempotente: recriar tabelas sobre um banco existente pode
falhar. Ele também cria contas de exemplo com senhas demonstrativas e concede
privilégios; portanto, não o execute em produção. A conta que o executa precisa
ter permissão para criar bancos, objetos e usuários e conceder os privilégios
indicados no script.

Em `transacoes.sql`, a primeira transação insere um produto pela procedure,
atualiza seu preço para 120,00 e confirma as alterações. A segunda altera esse
preço e insere outro produto, mas desfaz ambas as mudanças. As consultas mostram
os resultados antes e depois do rollback. Os SKUs são específicos para o
exemplo; execute-o uma vez após inicializar um banco limpo. A procedure não
confirma nem reverte a transação do chamador: em caso de erro, interrompa a
execução e faça `ROLLBACK` na mesma sessão; ao encerrar uma conexão sem commit,
o MySQL reverte a transação aberta.

## 7. Backup com mysqldump

Os arquivos incluídos são snapshots de dados fictícios criados após executar os
dois scripts. Eles foram gerados com MySQL 8.0; datas e metadados do dump
refletem a execução de origem e podem variar ao regenerá-los. Nunca publique
backups com dados reais ou credenciais sem autorização e revisão adequadas.

Para gerar novamente, configure um perfil de login `backup` que aponte para a
instância de origem e tenha privilégios de leitura e de acesso aos objetos
exportados. Use arquivos temporários no mesmo diretório e só substitua os
backups se o comando terminar com sucesso:

```sh
mysqldump --login-path=backup --default-character-set=utf8mb4 \
  --single-transaction --routines --events \
  --triggers --no-tablespaces --set-gtid-purged=OFF --databases loja \
  > backups/loja.sql.tmp && mv backups/loja.sql.tmp backups/loja.sql

mysqldump --login-path=backup --default-character-set=utf8mb4 \
  --single-transaction --routines --events \
  --triggers --no-tablespaces --set-gtid-purged=OFF \
  --databases loja universidade > backups/loja-universidade.sql.tmp \
  && mv backups/loja-universidade.sql.tmp backups/loja-universidade.sql
```

Remova o respectivo arquivo `.tmp` se o dump falhar e investigue o erro antes de
tentar novamente. `--databases` inclui a criação e seleção dos bancos;
`--routines`, `--triggers` e `--events` incluem os respectivos objetos
existentes. O projeto não cria eventos, portanto os dumps atuais não contêm
nenhum. As views também são incluídas. `--no-tablespaces` omite informações de
tablespaces, e `--set-gtid-purged=OFF` evita incluir configuração de GTIDs:
essas opções atendem a este exemplo e não substituem o planejamento de
replicação ou de recuperação de um ambiente real.

`--single-transaction` obtém um snapshot consistente das tabelas InnoDB, mas
não protege contra alterações concorrentes de DDL nem garante consistência de
tabelas não transacionais. Evite alterações de esquema durante o dump. Os
privilégios necessários variam conforme a versão e configuração do servidor.
Os dumps desses bancos não incluem usuários, grants globais nem a configuração
do servidor.

## 8. Recuperação e validação

Restaure **um** dos arquivos em uma instância MySQL 8 vazia e isolada, nunca
sobre bancos existentes que devam ser preservados: o dump contém comandos que
podem substituir objetos de mesmo nome. Configure antes um perfil `restauro`
para o servidor de destino e confira o host selecionado:

```sh
mysql --login-path=restauro --default-character-set=utf8mb4 < backups/loja.sql
# Ou, em outra instância vazia:
mysql --login-path=restauro --default-character-set=utf8mb4 < backups/loja-universidade.sql
```

As definições de views, procedures e triggers podem conter `DEFINER`. A conta
de restauração precisa dos privilégios adequados para recriar esses objetos, e
os definers e permissões necessários para executá-los devem existir no destino.
Recrie contas e grants separadamente quando necessário, sem reutilizar as
senhas demonstrativas em produção.

Os dois dumps foram restaurados separadamente em instâncias limpas. Os dados e
objetos foram comparados com a origem por dumps normalizados; também foram
exercitados procedures, triggers e view restaurados. Para uma conferência manual:

```sql
SELECT sku, preco_atual FROM loja.PRODUTO
WHERE sku IN ('TRANSACAO-COMMIT-001', 'TRANSACAO-ROLLBACK-001');
SHOW PROCEDURE STATUS WHERE Db IN ('loja', 'universidade');
SHOW TRIGGERS FROM loja;
SHOW FULL TABLES FROM universidade WHERE Table_type = 'VIEW';
```

O primeiro `SELECT` deve retornar somente `TRANSACAO-COMMIT-001`, com preço
`120.00`. As consultas referentes a `universidade` aplicam-se apenas ao backup
conjunto. Para recuperação operacional, teste restaurações periodicamente e
mantenha cópias seguras externas ao repositório.
