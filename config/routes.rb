# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :appcenter do
    namespace :webhooks do
      defaults format: :json do
        post :registrations, to: "registrations#create"
        post :statuses, to: "status#create"
      end
    end

    resources :messages, only: %i[index]
    resources :rooms, only: %i[index show] do
      resources :qiscus_messages, only: %i[update]
      resources :messages, only: %i[edit update]
    end

    resources :sessions, only: %i[show], constraints: { id: /.*/ } # params[:id] is jwt encoded token
    resources :accounts, only: %i[index create]
    resources :embeddings, only: %i[index create show update destroy] do
      resources :imports, only: %i[index create]

      member do
        post :train, to: "embeddings#train"
        post :activation, to: "embeddings#activation"
      end

      collection do
        get :fetch_contents, to: "embeddings#fetch_contents"
        resources "wordpress", only: %i[index create]
      end
    end

    resources :articles, only: [:create]

    resources :widgets, only: %i[index]

    get :home, to: "home#index"

    namespace :settings do
    end
  end

  namespace :webhooks do
    post "chatbot/:id", to: "chatbot#update", as: "chatbot"
  end

  # Error handler
  # This code related to the loc in config/application.rb
  # config.exceptions_app = routes
  get "/401", to: "errors#unauthorized", as: :unauthorized
  get "/404", to: "errors#not_found", as: :not_found
  get "/422", to: "errors#unprocessable_entity", as: :unprocessable_entity
  get "/500", to: "errors#internal_server", as: :internal_server_error
end
