Feature: Cliente Service API
  As a client of the system
  I want to interact with the Cliente API
  So that I can create, fetch, update clients and perform login

  Background:
    # Define o endpoint da API para ser utilizado nos steps
    Given the API endpoint is set to "http://api.example.com"

  # Cenários para create_cliente

  Scenario: Criar um cliente com payload válido
    Given a valid cliente payload:
      | nome             | data_nascimento | cpf         | email                    | password            |
      | João da Silva    | 1990-01-01      | 12345678901 | joao.silva@example.com   | @TechChallenge!2024 |
    When I send a request to create the cliente
    Then the response status should be 201
    And the response should contain the cliente data

  Scenario: Não criar um cliente se faltar campo obrigatório
    Given a cliente payload missing "email":
      | nome             | data_nascimento | cpf         | password            |
      | João da Silva    | 1990-01-01      | 12345678901 | @TechChallenge!2024 |
    When I send a request to create the cliente
    Then I should receive an error message containing "email"

  # Cenários para fetch_clientes

  Scenario: Buscar todos os clientes
    When I send a request to fetch all clientes
    Then the response should be a list of clientes

  # Cenários para fetch_cliente

  Scenario: Buscar um cliente por ID válido
    Given a cliente with ID "1" exists
    When I send a request to fetch the cliente with ID "1"
    Then the response should contain the cliente with ID "1"

  Scenario: Falhar ao buscar um cliente com ID inválido
    When I send a request to fetch the cliente with a blank ID
    Then I should receive an error message containing "ID inválido"

  # Cenários para update_cliente

  Scenario: Atualizar um cliente com ID e payload válidos
    Given a valid update payload:
      | nome          | email                             |
      | João da Silva | joao.silva_updated@example.com    |
    And a cliente with ID "1" exists
    When I send a request to update the cliente with ID "1" with the payload
    Then the response status should be 200

  Scenario: Falhar ao atualizar um cliente com ID inválido
    Given a valid update payload:
      | nome          | email                             |
      | João da Silva | joao.silva_updated@example.com    |
    When I send a request to update the cliente with a blank ID with the payload
    Then I should receive an error message containing "ID inválido"

  # Cenários para login

  Scenario: Realizar login com credenciais válidas
    Given valid login credentials:
      | cpf         | password            |
      | 12345678901 | @TechChallenge!2024 |
    When I send a login request with the credentials
    Then the response status should be 200
    And the response should contain an authentication token

  Scenario: Falhar ao realizar login com campo obrigatório ausente
    Given login credentials missing "password":
      | cpf         |
      | 12345678901 |
    When I send a login request with the credentials
    Then I should receive an error message containing "password"
