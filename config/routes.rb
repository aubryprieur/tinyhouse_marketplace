Rails.application.routes.draw do
  # Devise routes for Users
  devise_for :users

  # Routes for Houses
  resources :houses, only: [:index, :show]

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Vous pouvez définir une de vos actions comme page d'accueil, par exemple :
  root "houses#index"
end

