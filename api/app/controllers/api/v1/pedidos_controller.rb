module Api
  module V1
    class PedidosController < ApplicationController
      # GET /api/v1/pedidos
      def index
        response = PedidoService.fetch_pedidos
        render json: response.parsed_response, status: response.code
      end

      # GET /api/v1/pedidos/:id
      def show
        response = PedidoService.fetch_pedido(params[:id])
        render json: response.parsed_response, status: response.code
      end

      # POST /api/v1/pedidos
      def create
        begin
          response = PedidoService.create_pedido(pedido_params.to_h)
          render json: response.parsed_response, status: response.code
        rescue ArgumentError => e
          render json: { error: e.message }, status: :unprocessable_entity
        end
      end

      # PUT /api/v1/pedidos/:id
      def update
        response = PedidoService.update_pedido(params[:id], pedido_params.to_h)
        render json: response.parsed_response, status: response.code
      end

      # Ações customizadas – PUT /api/v1/pedidos/:id/{action}
      %w[pagar receber preparar pronto finalizar].each do |action_name|
        define_method(action_name) do
          response = PedidoService.action_pedido(params[:id], action_name)
          render json: response.parsed_response, status: response.code
        end
      end

      # GET /api/v1/pedidos/:id/qr-code
      def qr_code
        response = PedidoService.fetch_qr_code(params[:id])
        render json: response.parsed_response, status: response.code
      end

      private

      def pedido_params
        params.require(:pedido).permit(
          :id, :valor, :status, :observacao, :data, :data_status, :pagamento,
          cliente: [:nome, :email, :cpf, :token],
          produtos: [:id, :slug, :nome, :preco]
        )
      end
    end
  end
end

