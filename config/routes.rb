Rails.application.routes.draw do
  # Devise routes for Users
  devise_for :users

  # Routes for Houses
  resources :houses do
    resource :favorites, only: [:create, :destroy]
    resources :payments, only: [:new, :create] do
      collection do
        get 'success', to: 'payments#success', as: 'success'
      end
    end
    resources :messages, only: [:new, :create]
    resources :reports, only: :create

    member do
      patch 'validate', to: 'houses#validate', as: 'validate'
      patch 'feature', to: 'houses#feature', as: 'feature'
    end
  end

  # Additional routes for specific actions
  get "up" => "rails/health#show", as: :rails_health_check
  get 'search_houses', to: 'houses#search'
  get 'favorites', to: 'users#favorites', as: 'user_favorites'
  get 'users/:id/messages', to: 'users#messages', as: 'user_messages'

  # Admin dashboard with authentication constraint
  authenticate :user, lambda { |u| u.super_admin? } do
    get 'admin/dashboard', as: 'admin_dashboard'
    resources :reports, only: [:index, :show, :update]
    patch 'reports/:id/resolve', to: 'reports#resolve', as: 'resolve_report'
  end

  # Home page
  root "houses#index"
end
