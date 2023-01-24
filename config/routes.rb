Rails.application.routes.draw do
  
  root 'static_pages#home'
  resources :users
  
  resources :posts do
    resources:comments,only:[:create,
    :destroy]
  end
  
  get '/signup', to:'users#new' 
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'

  namespace :api, { format: 'json' } do
    resources :likes, only: [:index, :create, :destroy]
  end

end