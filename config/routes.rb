Rails.application.routes.draw do
  
  root 'static_pages#home'
  # 修正前
  # resources :users do
  #   resource :relationships, only: [:create, :destroy]
  #   member do
  #     get :following,:followers
  # end 

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :posts do
    resources:comments,only:[:create,:destroy]
    resource:likes,only: [:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]

  get '/signup', to:'users#new' 
  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  get '/search', to: 'posts#search'
end