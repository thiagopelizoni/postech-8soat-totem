module PedidoService
  include HTTParty
  base_uri ENV.fetch("API_PEDIDO")

  # GET /pedidos
  def self.fetch_pedidos
    get('/pedidos')
  end

  # GET /pedidos/{id}
  def self.fetch_pedido(id)
    raise ArgumentError, 'ID inválido' if id.blank?
    get("/pedidos/#{id}")
  end

  # GET endpoints por status (ex.: prontos, recebidos, etc.)
  def self.fetch_pedidos_by_status(status)
    raise ArgumentError, 'Status inválido' if status.blank?
    get("/pedidos/#{status}")
  end

  # POST /pedidos
  def self.create_pedido(params)
    required_keys = %w[id cliente produtos valor status observacao data data_status pagamento]
    missing_keys = required_keys.select { |key| params[key].blank? }
    raise ArgumentError, "Chaves obrigatórias faltando: #{missing_keys.join(', ')}" if missing_keys.any?

    post('/pedidos',
         body: params.to_json,
         headers: { 'Content-Type' => 'application/json' })
  end

  # PUT /pedidos/{id}
  def self.update_pedido(id, params)
    raise ArgumentError, 'ID inválido' if id.blank?
    put("/pedidos/#{id}",
        body: params.to_json,
        headers: { 'Content-Type' => 'application/json' })
  end

  # PUT actions: pagar, receber, preparar, pronto, finalizar
  def self.action_pedido(id, action)
    allowed_actions = %w[pagar receber preparar pronto finalizar]
    raise ArgumentError, "Ação inválida" unless allowed_actions.include?(action)
    put("/pedidos/#{id}/#{action}",
        body: { id: id }.to_json,
        headers: { 'Content-Type' => 'application/json' })
  end

  # GET /pedidos/{id}/qr-code
  def self.fetch_qr_code(id)
    raise ArgumentError, 'ID inválido' if id.blank?
    get("/pedidos/#{id}/qr-code")
  end
end

