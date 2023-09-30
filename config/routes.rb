Rails.application.routes.draw do
  
  root 'static_pages#home'
  
  resources :users do
    member do
      get :following, :followers,:likes,:personal_posts,:accountedit
      patch :accountupdate
    end
  end

  resources :posts do
    resources :comments,only:[:create,:destroy]
    resource :likes,only: [:create, :destroy]
  end

  resources :tags do
    get 'posts', to: 'posts#tags'
  end

  resources :relationships, only: [:create, :destroy]

  get '/signup', to:'users#new' 
  get '/login', to:'sessions#new'
  post '/guest', to: 'users#guest'
  post '/login', to:'sessions#create'
  delete '/logout', to:'sessions#destroy'
  get '/search', to: 'posts#search'
  get '/search_keyword', to: 'posts#search_keyword'
  get '/unsubscribe', to: 'users#unsubscribe'

end