require 'swagger_helper'

RSpec.describe 'Clientes API', type: :request do
  path '/api/v1/clientes' do
    get 'Lista todos os clientes' do
      tags 'Clientes'
      produces 'application/json'
      response '200', 'clientes listados' do
        run_test!
      end
    end

    post 'Cria um novo cliente' do
      tags 'Clientes'
      consumes 'application/json'
      parameter name: :cliente, in: :body, schema: {
        type: :object,
        properties: {
          nome: { type: :string },
          data_nascimento: { type: :string, format: 'date' },
          cpf: { type: :string },
          email: { type: :string, format: 'email' }
        },
        required: %w[nome data_nascimento cpf email]
      }

      response '201', 'cliente criado' do
        let(:cliente) { { nome: 'João da Silva', data_nascimento: '1990-01-01', cpf: '12345678901', email: 'joao.silva@example.com' } }
        run_test!
      end

      response '422', 'requisição inválida' do
        let(:cliente) { { nome: 'João da Silva' } }
        run_test!
      end
    end
  end

  path '/api/v1/clientes/{id}' do
    get 'Recupera um cliente' do
      tags 'Clientes'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      response '200', 'cliente encontrado' do
        let(:id) { '1' }
        run_test!
      end

      response '404', 'cliente não encontrado' do
        let(:id) { 'inexistente' }
        run_test!
      end
    end
  end

  path '/api/v1/login' do
    post 'Realiza o login' do
      tags 'Clientes'
      consumes 'application/json'
      parameter name: :cliente, in: :body, schema: {
        type: :object,
        properties: {
          cpf: { type: :string },
          password: { type: :string }
        },
        required: %w[cpf password]
      }
      response '200', 'login efetuado com sucesso' do
        let(:cliente) { { cpf: '12345678901', password: 'SenhaForte!123' } }
        run_test!
      end

      response '422', 'credenciais inválidas' do
        let(:cliente) { { cpf: '123', password: '' } }
        run_test!
      end
    end
  end
end
