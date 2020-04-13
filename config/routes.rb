Rails.application.routes.draw do
  root action: :index, controller: :home

  resources :users do
    member do
      get 'verify/:token', action: :verify, as: 'verification_token'
      get 'reset/:token', action: :edit, controller: :password_resets, as: 'reset_token'
      post 'reset/:token', action: :update, controller: :password_resets, as: 'reset_password'
    end
  end

  get 'password_resets/new'
  post 'password_resets/create'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
