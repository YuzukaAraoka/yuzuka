Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    
  resources :tweets
  get 'tweets/new' => 'tweets#new'
  get 'tweets' => 'tweets#index'
 resources :users, only: [:show]
  resources :perfumes
 
  root 'tweets#index'
  
end

