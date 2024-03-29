# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  post '/graphql', to: 'graphql#execute'
  get '/current_user', to: 'current_user#index'
  devise_for :users,
             path: '',
             path_names: { sign_in: 'login',
                           sign_out: 'logout',
                           registration: 'signup' },
             controllers: { sessions: 'users/sessions',
                            registrations: 'users/registrations' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/sidekiq'
end
