# AT23_JoaoVictor
# Sistema de Gestão OmniChannel

## Descrição do Projeto

Este projeto tem como objetivo desenvolver uma infraestrutura de banco de dados para um sistema de e-commerce OmniChannel, integrando vendas físicas e online. A solução utiliza MySQL para armazenar dados relacionais e MongoDB Atlas para registrar logs de navegação dos usuários.

## Objetivos

- Criar o Diagrama Entidade-Relacionamento (DER).
- Implementar tabelas e relacionamentos no MySQL.
- Inserir e consultar dados utilizando SQL.
- Criar uma Stored Procedure para processar vendas.
- Implementar uma Trigger para auditoria de alterações de preços.
- Configurar permissões de acesso ao banco de dados.
- Armazenar logs de navegação no MongoDB Atlas.
- Realizar backup do banco de dados e publicar o projeto no GitHub.

## Tecnologias Utilizadas

- MySQL Server
- MySQL Workbench
- MongoDB Atlas
- Visual Studio Code
- Git e GitHub
- SQL e JavaScript

## Estrutura do Projeto

```text
Projeto_OmniChannel/
├── docs/
│   ├── DER_OmniChannel.png
│   └── DER_OmniChannel.svg
├── scripts/
│   ├── 01_ddl_estrutura_e_seguranca.sql
│   ├── 02_dml_povoamento.sql
│   ├── 03_automacao_plsql.sql
│   └── 04_nosql_poc.js
├── cronograma.md
└── README.md
```

## Entidades do Banco de Dados

- **Clientes:** armazena os dados dos clientes.
- **Produtos:** registra os produtos e seus preços.
- **Lojas:** representa as lojas físicas e os canais de venda.
- **Estoque:** controla a quantidade de produtos por loja.
- **Pedidos:** armazena os pedidos realizados.
- **Itens_Pedido:** registra os produtos de cada pedido.
- **Pagamentos:** armazena informações dos pagamentos.
- **Auditoria_Preco:** registra alterações nos preços dos produtos.

O diagrama DER está disponível na pasta `docs`.

## Como Executar o Projeto

1. Abra o MySQL Workbench e conecte-se ao servidor MySQL.
2. Execute o arquivo `01_ddl_estrutura_e_seguranca.sql` para criar o banco e as tabelas.
3. Execute `02_dml_povoamento.sql` para inserir os dados de demonstração.
4. Execute `03_automacao_plsql.sql` para criar a Stored Procedure e a Trigger.
5. Teste as automações utilizando os comandos de exemplo presentes no script.
6. Configure o MongoDB Atlas e execute `04_nosql_poc.js` no MongoDB Playground do VS Code.
7. Gere o backup do banco utilizando a opção **Server → Data Export** no MySQL Workbench.

## Segurança

O projeto utiliza permissões específicas para controlar o acesso aos dados. As credenciais devem ser protegidas, e senhas reais nunca devem ser publicadas no GitHub.

## Resultados Esperados

- Banco de dados relacional estruturado.
- Dados de demonstração inseridos e consultáveis.
- Processamento de vendas com atualização de estoque.
- Auditoria automática das alterações de preços.
- Registro de logs de navegação no MongoDB Atlas.
- Documentação e scripts organizados para avaliação.

## Autor

João Victor Bezerra de Farias

## Observação

Este projeto possui finalidade educacional e utiliza dados fictícios para demonstração das funcionalidades.
