Rails.application.routes.draw do

  devise_for :users

  devise_scope :user do
    root to: 'devise/sessions#new'
    get :'/users/sign_out', to: 'devise/sessions#destroy', as: :logout
  end

  namespace :admin do
    get    :'/users',           to: 'users#index',  as: :users
    get    :'/user/:id',        to: 'users#show',   as: :show_user,   constraints: { id: /[0-9]+/ }
    get    :'/edit/user/:id',   to: 'users#edit',   as: :edit_user,   constraints: { id: /[0-9]+/ }
    patch  :'/update/user/:id', to: 'users#update', as: :update_user, constraints: { id: /[0-9]+/ }
  end

  namespace :api do
    namespace :v1 do
      post :'/user_tokens', to: 'user_tokens#create', as: :user_tokens
      get :'/address/:zip_code', to: 'addresses#show', as: :addresses, constraints: { zip_code: /[0-9\-]+/ }
    end
  end

end
