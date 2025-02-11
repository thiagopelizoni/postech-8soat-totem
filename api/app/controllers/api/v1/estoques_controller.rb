module Api
  module V1
    class EstoquesController < ApplicationController
      # GET /api/v1/categorias(/:slug)
      def categorias
        response = if params[:slug]
                     EstoqueService.fetch_categoria(params[:slug])
                   else
                     EstoqueService.fetch_categorias
                   end
        render json: response.parsed_response, status: response.code
      end

      # GET /api/v1/produtos(/:slug)
      def produtos
        response = if params[:slug]
                     EstoqueService.fetch_produto(params[:slug])
                   else
                     EstoqueService.fetch_produtos
                   end
        render json: response.parsed_response, status: response.code
      end
    end
  end
end

