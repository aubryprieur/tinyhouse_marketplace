Rails.application.routes.draw do
  # Devise routes for Users
  devise_for :users

  # Routes for Houses
  resources :houses do
    resource :favorites, only: [:create, :destroy]
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  get 'search_houses', to: 'houses#search'
  patch '/houses/:id/feature', to: 'houses#feature', as: :feature_house

  resources :houses do
    resources :messages, only: [:new, :create]
  end
  get 'users/:id/messages', to: 'users#messages', as: 'user_messages'
  get 'favorites', to: 'users#favorites', as: 'user_favorites'

  resources :houses do
    resources :reports, only: :create
  end

  authenticate :user, lambda { |u| u.super_admin? } do
    get 'admin/dashboard', to: 'admin#dashboard', as: 'admin_dashboard'
    patch 'reports/:id/resolve', to: 'reports#resolve', as: 'resolve_report'
  end

  # Vous pouvez définir une de vos actions comme page d'accueil, par exemple :
  root "houses#index"
end

