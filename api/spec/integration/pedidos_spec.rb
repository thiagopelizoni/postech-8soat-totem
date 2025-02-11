require 'swagger_helper'

RSpec.describe 'Pedidos API', type: :request do
  path '/api/v1/pedidos' do
    get 'Lista todos os pedidos' do
      tags 'Pedidos'
      produces 'application/json'
      response '200', 'pedidos encontrados' do
        run_test!
      end
    end

    post 'Cria um novo pedido' do
      tags 'Pedidos'
      consumes 'application/json'
      parameter name: :pedido, in: :body, schema: {
        type: :object,
        properties: {
          id: { type: :string, format: 'uuid' },
          cliente: {
            type: :object,
            properties: {
              nome: { type: :string },
              email: { type: :string, format: 'email' },
              cpf: { type: :number },
              token: { type: :string }
            },
            required: %w[nome email cpf token]
          },
          produtos: {
            type: :array,
            items: {
              type: :object,
              properties: {
                id: { type: :integer },
                slug: { type: :string },
                nome: { type: :string },
                preco: { type: :number }
              },
              required: %w[id slug nome preco]
            }
          },
          valor: { type: :number },
          status: { type: :string },
          observacao: { type: :string },
          data: { type: :string, format: 'date-time' },
          data_status: { type: :string, format: 'date-time' },
          pagamento: { type: :string }
        },
        required: %w[id cliente produtos valor status observacao data data_status pagamento]
      }

      response '201', 'pedido criado' do
        let(:pedido) do
          {
            id: '123e4567-e89b-12d3-a456-426614174000',
            cliente: {
              nome: 'Cliente Teste',
              email: 'cliente@example.com',
              cpf: 12345678900,
              token: 'abc123'
            },
            produtos: [
              {
                id: 1,
                slug: 'brownie',
                nome: 'Brownie',
                preco: 9
              }
            ],
            valor: 9,
            status: 'recebido',
            observacao: 'Pedido realizado com sucesso.',
            data: '2025-02-10T12:00:00Z',
            data_status: '2025-02-10T12:00:00Z',
            pagamento: 'em_aberto'
          }
        end
        run_test!
      end

      response '422', 'requisição inválida' do
        let(:pedido) { { id: '' } }
        run_test!
      end
    end
  end

  path '/api/v1/pedidos/{id}' do
    get 'Recupera um pedido' do
      tags 'Pedidos'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string
      response '200', 'pedido encontrado' do
        let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
        run_test!
      end

      response '404', 'pedido não encontrado' do
        let(:id) { 'inexistente' }
        run_test!
      end
    end
  end
end
