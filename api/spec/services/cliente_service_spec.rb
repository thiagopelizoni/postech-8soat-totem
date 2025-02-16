require 'rails_helper'

RSpec.describe ClienteService do
  describe '.create_cliente' do
    let(:valid_params) do
      {
        "cliente" => {
          "nome" => "João da Silva",
          "data_nascimento" => "1990-01-01",
          "cpf" => "12345678901",
          "email" => "joao.silva@example.com",
          "password" => "@TechChallenge!2024"
        }
      }
    end

    it 'realiza POST para criar um cliente com payload válido' do
      stub_request(:post, "#{ENV.fetch('API_CLIENTE')}/clientes")
        .with(
          body: valid_params.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
        .to_return(status: 201, body: valid_params.to_json, headers: {})

      response = ClienteService.create_cliente(valid_params)
      expect(response.code).to eq(201)
    end

    it 'lança erro se faltarem chaves obrigatórias' do
      invalid_params = valid_params.deep_dup
      invalid_params["cliente"].delete("email")
      
      expect { ClienteService.create_cliente(invalid_params) }
        .to raise_error(ArgumentError, /email/)
    end
  end
end
