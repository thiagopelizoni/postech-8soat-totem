Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  
  root to: redirect('/api-docs')

  namespace :api do
    namespace :v1 do
      # Endpoints para Estoque
      get 'categorias(/:slug)', to: 'estoques#categorias', as: 'categorias'
      get 'produtos(/:slug)', to: 'estoques#produtos', as: 'produtos'

      # Endpoints para Cliente
      resources :clientes, only: [:index, :show, :create, :update]
      post 'login', to: 'clientes#login'

      # Endpoints para Pedido
      resources :pedidos, only: [:index, :show, :create, :update] do
        member do
          put 'pagar'
          put 'receber'
          put 'preparar'
          put 'pronto'
          put 'finalizar'
          get 'qr-code', action: 'qr_code'
        end
        collection do
          get 'prontos'
          get 'recebidos'
          get 'em-preparacao'
          get 'finalizados'
          get 'pagamento-confirmado'
          get 'pagamento-em-aberto'
          get 'pagamento-recusado'
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

end
