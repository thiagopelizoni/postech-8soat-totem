require 'swagger_helper'

RSpec.describe 'Pedidos API', type: :request do
  path '/api/v1/pedidos' do
    get 'Lista todos os pedidos' do
      tags 'Pedidos'
      produces 'application/json'
      response '200', 'pedidos encontrados' do
        schema type: :array, items: { '$ref' => '#/components/schemas/Pedido' }
        run_test!
      end
    end

    post 'Cria um novo pedido' do
      tags 'Pedidos'
      consumes 'application/json'
      parameter name: :pedido, in: :body, schema: { '$ref' => '#/components/schemas/Pedido' }
      
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
    parameter name: :id, in: :path, type: :string, description: 'ID do pedido'

    get 'Recupera um pedido' do
      tags 'Pedidos'
      produces 'application/json'
      response '200', 'pedido encontrado' do
        schema '$ref' => '#/components/schemas/Pedido'
        let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
        run_test!
      end

      response '404', 'pedido não encontrado' do
        let(:id) { 'inexistente' }
        run_test!
      end
    end

    put 'Atualiza um pedido' do
      tags 'Pedidos'
      consumes 'application/json'
      parameter name: :pedido, in: :body, schema: { '$ref' => '#/components/schemas/Pedido' }
      response '200', 'pedido atualizado' do
        let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
        let(:pedido) do
          {
            id: '123e4567-e89b-12d3-a456-426614174000',
            cliente: {
              nome: 'Cliente Atualizado',
              email: 'atualizado@example.com',
              cpf: 98765432100,
              token: 'xyz789'
            },
            produtos: [
              {
                id: 2,
                slug: 'cheeseburger',
                nome: 'Cheeseburger',
                preco: 10
              }
            ],
            valor: 10,
            status: 'pronto',
            observacao: 'Pedido atualizado com sucesso.',
            data: '2025-02-10T13:00:00Z',
            data_status: '2025-02-10T13:00:00Z',
            pagamento: 'confirmado'
          }
        end
        run_test!
      end

      response '422', 'requisição inválida' do
        let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
        let(:pedido) { { id: '' } }
        run_test!
      end
    end
  end

  %w[pagar receber preparar pronto finalizar].each do |action|
    path "/api/v1/pedidos/{id}/#{action}" do
      parameter name: :id, in: :path, type: :string, description: 'ID do pedido'
      put "#{action.capitalize} um pedido" do
        tags 'Pedidos'
        consumes 'application/json'
        parameter name: :pedido, in: :body, schema: {
          type: :object,
          properties: {
            id: { type: :string }
          },
          required: ['id']
        }
        response '200', "pedido #{action} com sucesso" do
          let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
          let(:pedido) { { id: id } }
          run_test!
        end

        response '422', 'requisição inválida' do
          let(:id) { '' }
          let(:pedido) { { id: '' } }
          run_test!
        end
      end
    end
  end

  path '/api/v1/pedidos/{id}/qr-code' do
    parameter name: :id, in: :path, type: :string, description: 'ID do pedido'
    get 'Recupera o QR Code do pedido' do
      tags 'Pedidos'
      produces 'application/json'
      response '200', 'QR Code retornado' do
        schema type: :object,
               properties: {
                 id: { type: :string },
                 qr_code: { type: :string }
               },
               required: ['id', 'qr_code']
        let(:id) { '123e4567-e89b-12d3-a456-426614174000' }
        run_test!
      end

      response '404', 'pedido não encontrado' do
        let(:id) { 'inexistente' }
        run_test!
      end
    end
  end

  # Endpoints de coleção para filtros por status
  {
    'prontos' => 'Lista pedidos prontos',
    'recebidos' => 'Lista pedidos recebidos',
    'em-preparacao' => 'Lista pedidos em preparação',
    'finalizados' => 'Lista pedidos finalizados',
    'pagamento-confirmado' => 'Lista pedidos com pagamento confirmado',
    'pagamento-em-aberto' => 'Lista pedidos com pagamento em aberto',
    'pagamento-recusado' => 'Lista pedidos com pagamento recusado'
  }.each do |endpoint, description|
    path "/api/v1/pedidos/#{endpoint}" do
      get description do
        tags 'Pedidos'
        produces 'application/json'
        response '200', 'lista de pedidos retornada' do
          schema type: :array, items: { '$ref' => '#/components/schemas/Pedido' }
          run_test!
        end
      end
    end
  end
end
