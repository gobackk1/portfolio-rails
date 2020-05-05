Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    resources :users
    get '/users/:id/report', to: 'users#report'
    post '/users/search', to: 'users#search'
    resources :study_records do
      resources :study_record_comments, only: [:create, :destroy]
    end
    post '/study_records/search', to: 'study_records#search'
    resources :likes, only: [:create, :destroy]
    get '/likes/:id/all', to: 'likes#all'
    resources :relationships, only: [:create, :destroy]
    post '/login', to: 'users#login'
  end
end
