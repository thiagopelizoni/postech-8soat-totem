# Pos Tech FIAP | Software Arquitecture | 8SOAT | Totem

Tech Challenge do curso de [Pós-Graduação em Arquitetura de Software da FIAP](https://postech.fiap.com.br/curso/software-architecture/).

Microsserviço de Totem, responsável por interagir com o microsserviço Cliente, microsserviço Estoque e microsserviço Pedido.

# Requisitos

* [Docker](https://docs.docker.com/engine/install/)
* [Docker Compose](https://github.com/docker/compose)

# Instalação

Caso não exista o arquivo *.env* previamente configurado, utilize o [.env.example](.env.example) como modelo.

```
[ ! -f .env ] && cp .env.example .env
```

Após ajustar todos os valores presentes no arquivo *.env*, basta executar o comando abaixo:


```
docker-compose up --build -d
```

A aplicação estará disponível em http://localhost:3000/ supondo o valor RAILS_PORT=3000 no arquivo *.env*.