require 'rails_helper'

RSpec.describe PedidoService do
  describe '.fetch_pedidos' do
    it 'realiza uma requisição GET para /pedidos e retorna os dados' do
      pedidos_response = [{ "id" => "123", "status" => "recebido" }]
      stub_request(:get, "#{ENV.fetch('API_PEDIDO')}/pedidos")
        .to_return(status: 200, body: pedidos_response.to_json, headers: { 'Content-Type' => 'application/json' })

      response = PedidoService.fetch_pedidos
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)).to eq(pedidos_response)
    end
  end

  describe '.fetch_pedido' do
    context 'quando o id é válido' do
      it 'realiza uma requisição GET para /pedidos/{id}' do
        id = '123e4567-e89b-12d3-a456-426614174000'
        pedido_response = { "id" => id, "status" => "recebido" }
        stub_request(:get, "#{ENV.fetch('API_PEDIDO')}/pedidos/#{id}")
          .to_return(status: 200, body: pedido_response.to_json, headers: { 'Content-Type' => 'application/json' })

        response = PedidoService.fetch_pedido(id)
        expect(response.code).to eq(200)
        expect(JSON.parse(response.body)).to eq(pedido_response)
      end
    end

    context 'quando o id é inválido' do
      it 'lança um ArgumentError' do
        expect { PedidoService.fetch_pedido('') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.create_pedido' do
    context 'quando os parâmetros são válidos' do
      it 'realiza uma requisição POST para /pedidos e cria o pedido' do
        pedido_params = {
          "id" => "123e4567-e89b-12d3-a456-426614174000",
          "cliente" => {
            "nome" => "Cliente Teste",
            "email" => "cliente@example.com",
            "cpf" => 12345678900,
            "token" => "abc123"
          },
          "produtos" => [
            { "id" => 1, "slug" => "brownie", "nome" => "Brownie", "preco" => 9 }
          ],
          "valor" => 9,
          "status" => "recebido",
          "observacao" => "Pedido realizado com sucesso.",
          "data" => "2025-02-10T12:00:00Z",
          "data_status" => "2025-02-10T12:00:00Z",
          "pagamento" => "em_aberto"
        }
        stub_request(:post, "#{ENV.fetch('API_PEDIDO')}/pedidos")
          .with(
            body: pedido_params.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 201, body: pedido_params.to_json, headers: { 'Content-Type' => 'application/json' })

        response = PedidoService.create_pedido(pedido_params)
        expect(response.code).to eq(201)
        expect(JSON.parse(response.body)).to eq(pedido_params)
      end
    end

    context 'quando faltam parâmetros obrigatórios' do
      it 'lança um ArgumentError' do
        invalid_params = { "id" => "123" } # parâmetros insuficientes
        expect { PedidoService.create_pedido(invalid_params) }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.update_pedido' do
    it 'realiza uma requisição PUT para /pedidos/{id} e atualiza o pedido' do
      id = '123e4567-e89b-12d3-a456-426614174000'
      pedido_params = {
        "id" => id,
        "cliente" => {
          "nome" => "Cliente Atualizado",
          "email" => "atualizado@example.com",
          "cpf" => 98765432100,
          "token" => "xyz789"
        },
        "produtos" => [
          { "id" => 2, "slug" => "cheeseburger", "nome" => "Cheeseburger", "preco" => 10 }
        ],
        "valor" => 10,
        "status" => "pronto",
        "observacao" => "Pedido atualizado com sucesso.",
        "data" => "2025-02-10T13:00:00Z",
        "data_status" => "2025-02-10T13:00:00Z",
        "pagamento" => "confirmado"
      }
      stub_request(:put, "#{ENV.fetch('API_PEDIDO')}/pedidos/#{id}")
        .with(
          body: pedido_params.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 200, body: pedido_params.to_json, headers: { 'Content-Type' => 'application/json' })

      response = PedidoService.update_pedido(id, pedido_params)
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)).to eq(pedido_params)
    end

    it 'lança um ArgumentError se o id for inválido' do
      expect { PedidoService.update_pedido('', {}) }.to raise_error(ArgumentError)
    end
  end

  describe '.action_pedido' do
    context 'quando a ação é permitida' do
      it 'realiza uma requisição PUT para a ação desejada' do
        id = '123e4567-e89b-12d3-a456-426614174000'
        action = 'pagar'
        stub_request(:put, "#{ENV.fetch('API_PEDIDO')}/pedidos/#{id}/#{action}")
          .with(
            body: { id: id }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )
          .to_return(status: 200, body: { id: id, status: 'pago' }.to_json, headers: { 'Content-Type' => 'application/json' })

        response = PedidoService.action_pedido(id, action)
        expect(response.code).to eq(200)
        parsed_body = JSON.parse(response.body)
        expect(parsed_body["id"]).to eq(id)
        expect(parsed_body["status"]).to eq("pago")
      end
    end

    context 'quando a ação não é permitida' do
      it 'lança um ArgumentError' do
        expect { PedidoService.action_pedido('123', 'acao_invalida') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.fetch_qr_code' do
    context 'quando o id é válido' do
      it 'realiza uma requisição GET para /pedidos/{id}/qr-code' do
        id = '123e4567-e89b-12d3-a456-426614174000'
        qr_response = { "id" => id, "qr_code" => "imagem_base64" }
        stub_request(:get, "#{ENV.fetch('API_PEDIDO')}/pedidos/#{id}/qr-code")
          .to_return(status: 200, body: qr_response.to_json, headers: { 'Content-Type' => 'application/json' })

        response = PedidoService.fetch_qr_code(id)
        expect(response.code).to eq(200)
        expect(JSON.parse(response.body)).to eq(qr_response)
      end
    end

    context 'quando o id é inválido' do
      it 'lança um ArgumentError' do
        expect { PedidoService.fetch_qr_code('') }.to raise_error(ArgumentError)
      end
    end
  end
end
