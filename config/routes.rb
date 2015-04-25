Rails.application.routes.draw do
  root 'home#index'

  resources :recipes, only: [:index, :show, :create, :update, :destroy]
end
