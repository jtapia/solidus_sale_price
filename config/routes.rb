Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :products do
      resources :sale_prices do
        get :stop
        get :enable
      end
    end
  end
end