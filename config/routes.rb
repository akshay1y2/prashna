Rails.application.routes.draw do
  root action: :index, controller: :home

  resources :users do
    member do
      get 'verify/:token', action: :verify, as: 'verification_token'
    end
  end

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
