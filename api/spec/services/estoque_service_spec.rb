require 'rails_helper'

RSpec.describe EstoqueService do
  describe '.fetch_categorias' do
    it 'realiza uma requisição GET para /categorias e retorna os dados' do
      categorias_response = [{ "slug" => "doces", "nome" => "Doces" }]
      stub_request(:get, "#{ENV.fetch('API_ESTOQUE')}/categorias")
        .to_return(status: 200, body: categorias_response.to_json, headers: { 'Content-Type' => 'application/json' })

      response = EstoqueService.fetch_categorias
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)).to eq(categorias_response)
    end
  end

  describe '.fetch_categoria' do
    context 'quando o slug_categoria é válido' do
      it 'realiza uma requisição GET para /categorias/{slug_categoria}' do
        slug = 'doces'
        categoria_response = { "slug" => "doces", "nome" => "Doces" }
        stub_request(:get, "#{ENV.fetch('API_ESTOQUE')}/categorias/#{slug}")
          .to_return(status: 200, body: categoria_response.to_json, headers: { 'Content-Type' => 'application/json' })

        response = EstoqueService.fetch_categoria(slug)
        expect(response.code).to eq(200)
        expect(JSON.parse(response.body)).to eq(categoria_response)
      end
    end

    context 'quando o slug_categoria é inválido' do
      it 'lança um ArgumentError' do
        expect { EstoqueService.fetch_categoria('') }.to raise_error(ArgumentError)
      end
    end
  end

  describe '.fetch_produtos' do
    it 'realiza uma requisição GET para /produtos e retorna os dados' do
      produtos_response = [{ "slug" => "brownie", "nome" => "Brownie" }]
      stub_request(:get, "#{ENV.fetch('API_ESTOQUE')}/produtos")
        .to_return(status: 200, body: produtos_response.to_json, headers: { 'Content-Type' => 'application/json' })

      response = EstoqueService.fetch_produtos
      expect(response.code).to eq(200)
      expect(JSON.parse(response.body)).to eq(produtos_response)
    end
  end

  describe '.fetch_produto' do
    context 'quando o slug_produto é válido' do
      it 'realiza uma requisição GET para /produtos/{slug_produto}' do
        slug = 'brownie'
        produto_response = { "slug" => "brownie", "nome" => "Brownie", "preco" => 9 }
        stub_request(:get, "#{ENV.fetch('API_ESTOQUE')}/produtos/#{slug}")
          .to_return(status: 200, body: produto_response.to_json, headers: { 'Content-Type' => 'application/json' })

        response = EstoqueService.fetch_produto(slug)
        expect(response.code).to eq(200)
        expect(JSON.parse(response.body)).to eq(produto_response)
      end
    end

    context 'quando o slug_produto é inválido' do
      it 'lança um ArgumentError' do
        expect { EstoqueService.fetch_produto('') }.to raise_error(ArgumentError)
      end
    end
  end
end
