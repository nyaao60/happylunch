Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    resources :likes, only: [:index, :create, :destroy]
  end
  root 'static_pages#home'
  get '/signup', to:'users#new' 
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  resources :users
  resources :posts 
end