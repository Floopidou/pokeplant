Rails.application.routes.draw do
  devise_for :users

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  #test chat
  get 'chat_test', to: 'chats#test'

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # static pages
  # root to: "pages#home"
  get "loading", to: "pages#loading"
  get "", to: "plants#index"

  # route with reminders for all plants of current user
  get "all_reminders", to: "pages#reminders", as: :reminders

  # plants
  resources :plants do
    # chat linked to plant
    resources :chats, only: [:create,:index,:show, :destroy] do
      resources :messages, only: :create
    end
    # route with reminders for this plant
    member do
      # new plant creation helpers
      get :choose_name
      patch :apply_name

      get :select_tags
      patch :apply_tags

      #infos page
      get :infos
      get :care

      # other useful routes
      get :plant_reminders # builds a list of reminders linked to my plants
      patch :update_name # change name of my plant
      patch :water # waters the plant
      patch :repot # repots the plant
      patch :pet # pets the plant

      #get :plant_menu
    end

    resources :pots, only: [:index] do
      resources :plant_pot_pairs, only: [:create, :update] # buying a new pot = creating a plant_pot_pairs
    end

    resources :plant_pot_pairs, only: [:destroy]
  end

end
