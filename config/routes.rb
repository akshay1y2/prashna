Rails.application.routes.draw do
  resources :users, only: [:new, :edit, :create, :update] do
    member do
      get 'verify/:token', action: :verify, as: 'verification_token'
      get 'reset/:token', action: :edit, controller: :password_resets, as: 'reset_token'
      post 'reset/:token', action: :update, controller: :password_resets, as: 'reset_password'
    end
    collection do
      get 'notifications', action: :index, controller: :notifications
      get 'profile'
    end
  end

  resources :questions do
    get 'drafts', on: :collection
    member do
      post 'comment', action: :create, controller: :comments
    end
  end

  get 'topics', action: :search, controller: :topics
  get 'notifications_count', action: :count, controller: :notifications
  get 'mark_notification', action: :mark_viewed, controller: :notifications
  get 'password_resets/new'
  post 'password_resets/create'

  namespace :admin do
    resources :users, only: [:index, :show, :destroy]
  end

  controller :sessions do
    get 'login', action: :new
    post 'login', action: :create
    delete 'logout', action: :destroy
  end

  root action: :index, controller: :questions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
