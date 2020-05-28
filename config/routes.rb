Rails.application.routes.draw do
  resources :users, only: [:new, :edit, :create, :update, :show] do
    member do
      get 'verify/:token', action: :verify, as: 'verification_token'
      get 'reset/:token', action: :edit, controller: :password_resets, as: 'reset_token'
      post 'reset/:token', action: :update, controller: :password_resets, as: 'reset_password'
      get 'credit_transactions', action: :index, controller: :credit_transactions
    end
  end

  resources :questions do
    get 'drafts', on: :collection
    resources :comments, only: [:create]
    resources :answers, only: [:create]
  end

  resources :answers do
    resources :comments, only: [:create]
  end

  get 'profile', to: 'users#profile'
  get 'notifications', to: 'notifications#index'
  get 'credit_transactions', to: 'credit_transactions#index'
  get 'payment_transactions', to: 'payment_transactions#index'
  resources :votes, only: [:create]
  resources :packs, only: [:index] do
    member do
      get 'payment', to: 'payment_transactions#new'
      post 'payment', to: 'payment_transactions#create'
    end
  end

  get 'topics', action: :search, controller: :topics
  get 'notifications_poll', action: :poll, controller: :notifications
  get 'mark_notification', action: :mark_viewed, controller: :notifications
  get 'password_resets/new'
  post 'password_resets/create'

  namespace :admin do
    get '/', to: 'users#index'
    resources :users, only: [:index, :edit, :update, :destroy] do
      get 'credit_transactions', on: :member, to: 'credit_transactions#index'
    end
  end

  controller :sessions do
    get 'login', action: :new
    post 'login', action: :create
    delete 'logout', action: :destroy
  end

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.production?
  root action: :index, controller: :questions
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
