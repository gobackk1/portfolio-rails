Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    resources :users
    resources :study_records do
      resources :study_record_comments, only:[:create, :destroy]
    end
    post '/login', to: 'users#login'
  end
end
