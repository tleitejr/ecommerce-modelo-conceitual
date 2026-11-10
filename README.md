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

**Este projeto não contém SQL, código de aplicação ou banco executável.**

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

Estrutura sugerida:

    ecommerce-modelo-conceitual/
    ├── README.md
    ├── diagrama.mmd
    └── exportacoes/
        ├── diagrama.png
        └── diagrama.pdf

- `README.md`: documentação do modelo.
- `diagrama.mmd`: código-fonte do diagrama Mermaid.
- `exportacoes/diagrama.png`: imagem exportada.
- `exportacoes/diagrama.pdf`: versão em PDF.
