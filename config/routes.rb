Rails.application.routes.draw do
  # Devise routes for Users
  devise_for :users

  # Routes for Houses
  resources :houses

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  get 'search_houses', to: 'houses#search'
  patch '/houses/:id/feature', to: 'houses#feature', as: :feature_house
  resources :houses do
    resources :messages, only: [:new, :create]
  end
  get 'users/:id/messages', to: 'users#messages', as: 'user_messages'

  # Vous pouvez définir une de vos actions comme page d'accueil, par exemple :
  root "houses#index"
end

