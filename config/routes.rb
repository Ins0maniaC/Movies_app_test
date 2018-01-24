Rails.application.routes.draw do
  root to: 'static#index'
  
  get '/feed',   to: 'static#feed'
  get '/api' => redirect('/swagger/dist/index.html?url=/api-docs.json')
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/movies/:id/follow', to: 'movies#follow'
  get '/movies/:id/unfollow', to: 'movies#unfollow'
  
  resources :users
  resources :movies do
    resources :topics, only: [:new, :create, :edit, :update, :show, :destroy] do
      resources :posts, only: [:new, :create, :edit, :update, :show, :destroy]
    end
  end
end
