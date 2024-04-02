Rails.application.routes.draw do
  # Devise routes for Users
  devise_for :users

  # Routes for Houses
  resources :houses

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
  get 'search_houses', to: 'houses#search'
  patch '/houses/:id/feature', to: 'houses#feature', as: :feature_house

  # Vous pouvez définir une de vos actions comme page d'accueil, par exemple :
  root "houses#index"
end

