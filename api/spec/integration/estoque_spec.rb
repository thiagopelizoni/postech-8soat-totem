require 'swagger_helper'

RSpec.describe 'Estoque API', type: :request do
  path '/api/v1/categorias' do
    get 'Lista todas as categorias' do
      tags 'Estoque'
      produces 'application/json'
      response '200', 'categorias encontradas' do
        run_test!
      end
    end
  end

  path '/api/v1/categorias/{slug}' do
    get 'Recupera uma categoria' do
      tags 'Estoque'
      produces 'application/json'
      parameter name: :slug, in: :path, type: :string
      response '200', 'categoria encontrada' do
        let(:slug) { 'alguma-categoria' }
        run_test!
      end

      response '404', 'categoria não encontrada' do
        let(:slug) { 'categoria-inexistente' }
        run_test!
      end
    end
  end

  path '/api/v1/produtos' do
    get 'Lista todos os produtos' do
      tags 'Estoque'
      produces 'application/json'
      response '200', 'produtos encontrados' do
        run_test!
      end
    end
  end

  path '/api/v1/produtos/{slug}' do
    get 'Recupera um produto' do
      tags 'Estoque'
      produces 'application/json'
      parameter name: :slug, in: :path, type: :string
      response '200', 'produto encontrado' do
        let(:slug) { 'brownie' }
        run_test!
      end

      response '404', 'produto não encontrado' do
        let(:slug) { 'produto-inexistente' }
        run_test!
      end
    end
  end
end
