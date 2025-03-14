# TODO autoloading order changed. This should be managed by configs instead:
# https://guides.rubyonrails.org/v7.0/autoloading_and_reloading_constants.html#autoloading-when-the-application-boots
require_relative '../app/controllers/api/v1/base'
require_relative '../app/controllers/api/base'

Rails.application.routes.draw do
  get 'agencies', to: 'agencies#index', defaults: { format: :json }
  get 'zip_lookup', to: 'zip_lookup#get', defaults: { format: :json }

  devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    resources :experiences, except: [:edit, :destroy]

    namespace :api do
      resources :docs, only: [:index]
    end

    mount Api::Base => '/api'

    get '/contact', to: 'contacts#new'
    get "/*id" => 'pages#show', as: :page, format: false
    root 'pages#index'

    resources "contacts", only: [:new, :create]
end
