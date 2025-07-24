Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  # get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
  get "home/index"
  get "chats/", to: "chat#index"
  resources :chat, only: [ :index, :show ] do
    member do
      get :check_updates
    end
  end

  devise_for :users

  resources :api_tokens

  namespace :api do
    namespace :v1 do
      defaults format: :json do
        get "home/index", to: "home#index"
        get "products", to: "products#index"
        get "products/cut_prise", to: "products#cut_prise"
        get "products/size", to: "products#size"
      end
    end
  end
end
