module EstoqueService
  include HTTParty
  base_uri ENV.fetch("API_ESTOQUE")

  # GET /categorias
  def self.fetch_categorias
    get('/categorias')
  end

  # GET /categorias/{slug_categoria}
  def self.fetch_categoria(slug_categoria)
    raise ArgumentError, 'slug_categoria não pode ser vazio' if slug_categoria.blank?
    get("/categorias/#{slug_categoria}")
  end

  # GET /produtos
  def self.fetch_produtos
    get('/produtos')
  end

  # GET /produtos/{slug_produto}
  def self.fetch_produto(slug_produto)
    raise ArgumentError, 'slug_produto não pode ser vazio' if slug_produto.blank?
    get("/produtos/#{slug_produto}")
  end
end
  
