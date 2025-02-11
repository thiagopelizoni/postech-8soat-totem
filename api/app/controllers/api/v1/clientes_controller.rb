module Api
  module V1
    class ClientesController < ApplicationController
      # GET /api/v1/clientes
      def index
        response = ClienteService.fetch_clientes
        render json: response.parsed_response, status: response.code
      end

      # GET /api/v1/clientes/:id
      def show
        response = ClienteService.fetch_cliente(params[:id])
        render json: response.parsed_response, status: response.code
      end

      # POST /api/v1/clientes
      def create
        begin
          response = ClienteService.create_cliente(cliente_params.to_h)
          render json: response.parsed_response, status: response.code
        rescue ArgumentError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # PATCH /api/v1/clientes/:id
      def update
        response = ClienteService.update_cliente(params[:id], cliente_update_params.to_h)
        render json: response.parsed_response, status: response.code
      end

      # POST /api/v1/login
      def login
        begin
          response = ClienteService.login(login_params.to_h)
          render json: response.parsed_response, status: response.code
        rescue ArgumentError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      private

      def cliente_params
        params.require(:cliente).permit(:nome, :data_nascimento, :cpf, :email)
      end

      def cliente_update_params
        params.require(:cliente).permit(:nome, :email)
      end

      def login_params
        params.require(:cliente).permit(:cpf, :password)
      end
    end
  end
end

