Rails.application.routes.draw do
  resources :categories
  resources :tasks do
    member do
      patch :complete
      patch :reorder
      patch :pending
    end

    collection do
      get :completed
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "tasks#index"
end
