# API Vertical Logística
API Rails para processamento de arquivos de pedidos desnormalizados.

## Stack
- Ruby 3.4.4
- Rails 8.0.2
- SQLite

## Abordagem
- Cada linha do arquivo de texto padrão a ser importado representa um "item de produto" comprado pelo usuário.
- Cada "item de produto" é composto por id do usuário, nome do usuário, id do pedido, id do produto, valor do produto, data da compra.
- Com base nas informações disponíveis, foram criados models para usuário (user), pedido (order) WIP
  
## Funcionalidades
### Importação de pedidos a partir de arquivo de texto
 - Importa os dados de pedidos a partir de um arquivo de texto padrão.
 - Um exemplo de arquivo padrão pode ser encontrado em `./db/support`.

<p><b>Endpoint:</b> POST /api/v1/orders/import</p>
<p><b>Params:</b> { file: [file] }</p>
<p><b>Retorno:</b> 201 (Created)</p>

```json
[
  {
    "user_id": 1,
    "name": "Sammie Baumbach",
    "orders": [
      {
        "order_id": 2,
        "date": "2021-10-28",
        "total": "2365.03",
        "products": [
          {
            "product_id": 2,
            "value": "798.03"
          },
          {
            "product_id": 5,
            "value": "1567.0"
          }
        ]
      },
      {
        "order_id": 3,
        "date": "2021-09-10",
        "total": "3509.62",
        "products": [
          {
            "product_id": 2,
            "value": "873.12"
          },
          {
            "product_id": 3,
            "value": "1740.63"
          },
          {
            "product_id": 4,
            "value": "895.87"
          }
        ]
      }
    ]
  },
  {
    "user_id": 2,
    "name": "Augustus Aufderhar",
    "orders": [
      {
        "order_id": 17,
        "date": "2021-07-14",
        "total": "274.31",
        "products": [
          {
            "product_id": 3,
            "value": "274.31"
          }
        ]
      },
      {
        "order_id": 18,
        "date": "2021-07-13",
        "total": "538.18",
        "products": [
          {
            "product_id": 1,
            "value": "538.18"
          }
        ]
      }
    ]  
  }
]
```

### Consulta geral de pedidos
 - Exibe uma lista dos pedidos armazenados no banco de dados, agrupados de acordo com o id original do comprador.
 - A lista está em ordem crescente de acordo com o id do comprador.
 - Os pedidos de cada comprador estão organizados em ordem crescente de acordo com o id original do pedido.
 - Os produtos de cada pedido estão organizados em ordem crescente de acordo com o id original do pedido.

<p><b>Endpoint:</b> GET /api/v1/orders</p>
<p><b>Retorno:</b> 200 (OK)</p>

```json
[
  {
    "user_id": 1,
    "name": "Sammie Baumbach",
    "orders": [
      {
        "order_id": 2,
        "date": "2021-10-28",
        "total": "2365.03",
        "products": [
          {
            "product_id": 2,
            "value": "798.03"
          },
          {
            "product_id": 5,
            "value": "1567.0"
          }
        ]
      },
      {
        "order_id": 3,
        "date": "2021-09-10",
        "total": "3509.62",
        "products": [
          {
            "product_id": 2,
            "value": "873.12"
          },
          {
            "product_id": 3,
            "value": "1740.63"
          },
          {
            "product_id": 4,
            "value": "895.87"
          }
        ]
      }
    ]
  },
  {
    "user_id": 2,
    "name": "Augustus Aufderhar",
    "orders": [
      {
        "order_id": 17,
        "date": "2021-07-14",
        "total": "274.31",
        "products": [
          {
            "product_id": 3,
            "value": "274.31"
          }
        ]
      },
      {
        "order_id": 18,
        "date": "2021-07-13",
        "total": "538.18",
        "products": [
          {
            "product_id": 1,
            "value": "538.18"
          }
        ]
      }
    ]  
  }
]
```

### Filtros de pedidos
 - Exibe uma lista filtrada dos pedidos armazenados no banco de dados.
 - Atualmente é possível filtrar os pedidos de acordo com o id original do pedido e com a data da compra.
   
#### Filtro pelo id original do pedido
 - Atualmente busca por ids iguais ao buscado e exibe uma lista com os resultados encontrados.
 - Como no momento o banco de dados não permite a criação de pedidos com o mesmo id original, a busca retornará a lista com somente 1 resultado contendo o usuário do pedido e o pedido em questão, caso exista.

<p><b>Endpoint:</b> GET /api/v1/orders?order_id=2</p>
<p><b>Retorno:</b> 200 (OK)</p>

```json
[
  {
    "user_id": 1,
    "name": "Sammie Baumbach",
    "orders": [
      {
        "order_id": 2,
        "date": "2021-10-28",
        "total": "2365.03",
        "products": [
          {
            "product_id": 2,
            "value": "798.03"
          },
          {
            "product_id": 5,
            "value": "1567.0"
          }
        ]
      }
    ]
  }
]
```

#### Filtro pela data de compra
 - É possível buscar um pedido de acordo com um intervalo de datas, a partir de determinada data (inclusa) ou até determinada data (inclusa).
 - São exibidos na lista somente usuários e pedidos que se enquadram nas datas especificadas.
   
<p><b>Endpoint:</b> GET /api/v1/orders?start_date=2021-07-14&end_date=2021-09-10</p>
<p><b>Retorno:</b> 200 (OK)</p>

```json
[
  {
    "user_id": 1,
    "name": "Sammie Baumbach",
    "orders": [
      {
        "order_id": 3,
        "date": "2021-09-10",
        "total": "3509.62",
        "products": [
          {
            "product_id": 2,
            "value": "873.12"
          },
          {
            "product_id": 3,
            "value": "1740.63"
          },
          {
            "product_id": 4,
            "value": "895.87"
          }
        ]
      }
    ]
  },
  {
    "user_id": 2,
    "name": "Augustus Aufderhar",
    "orders": [
      {
        "order_id": 17,
        "date": "2021-07-14",
        "total": "274.31",
        "products": [
          {
            "product_id": 3,
            "value": "274.31"
          }
        ]
      }
    ]  
  }
]
```

## Como rodar a aplicação
- Clone o projeto:
```
$ git clone git@github.com:raphaellyv/vertical-logistica.git
```

- Acesse a pasta do projeto:
```
$ cd vertical-logistica
```

- Execute os testes:
```
$ rspec
```

- Instale as dependências e prepare o banco de dados:
```
$ bin/setup
```

- Inicie o servidor:
```
$ rails s
```

- Importe os dados pelo endpoint de importação de pedidos em http://localhost:300/api/v1/orders/import.

## Melhorias
- Adicionar autenticação.
- Adicionar paginação.
- Adicionar gem RuboCop para aperfeiçoar o código.
- Investigar Active Model Serialization para montar o json retornado pela API.
- Dockerizar a aplicação.
- Adicionar Redis e Sidekiq para processamento assíncrono.
- Alterar banco de dados para PostgreSQL.