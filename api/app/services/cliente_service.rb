module ClienteService
  include HTTParty
  base_uri ENV.fetch("API_CLIENTE")

  # GET /clientes
  def self.fetch_clientes
    get('/clientes')
  end

  # GET /clientes/{id}
  def self.fetch_cliente(id)
    raise ArgumentError, 'ID inválido' if id.blank?
    get("/clientes/#{id}")
  end

  # POST /clientes
  def self.create_cliente(params)
    required_keys = %w[nome data_nascimento cpf email]
    missing_keys = required_keys.select { |key| params[key].blank? }
    raise ArgumentError, "Chaves obrigatórias faltando: #{missing_keys.join(', ')}" if missing_keys.any?

    post('/clientes',
         body: params.to_json,
         headers: { 'Content-Type' => 'application/json' })
  end

  # PATCH /clientes/{id}
  def self.update_cliente(id, params)
    raise ArgumentError, 'ID inválido' if id.blank?
    patch("/clientes/#{id}",
          body: params.to_json,
          headers: { 'Content-Type' => 'application/json' })
  end

  # POST /login
  def self.login(params)
    required_keys = %w[cpf password]
    missing_keys = required_keys.select { |key| params[key].blank? }
    raise ArgumentError, "Chaves obrigatórias faltando: #{missing_keys.join(', ')}" if missing_keys.any?

    post('/login',
         body: params.to_json,
         headers: { 'Content-Type' => 'application/json' })
  end
end

