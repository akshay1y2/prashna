Rails.application.routes.draw do
  resources :users do
    member do
      get 'verify/:token', action: :verify, as: 'verification_token'
      get 'reset/:token', action: :edit, controller: :password_resets, as: 'reset_token'
      post 'reset/:token', action: :update, controller: :password_resets, as: 'reset_password'
    end
    get 'notifications', on: :collection
  end

  resources :questions do
    get 'drafts', on: :collection
  end

  get 'topics', action: :search, controller: :topics
  get 'notifications', action: :fetch, controller: :notifications
  get 'password_resets/new'
  post 'password_resets/create'

  controller :sessions do
    get 'login', action: :new
    post 'login', action: :create
    delete 'logout', action: :destroy
  end

  root action: :index, controller: :questions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
