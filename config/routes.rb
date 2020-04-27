Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    resources :users, only:[:create]
    post '/login', to: 'users#login'
    #test
    get '/cu', to: 'users#cu'
  end
end
