Rails.application.routes.draw do
  root 'home#index'
  post '/park', to: 'parking#park'
  post '/unpark', to: 'parking#unpark'
  resources :parking, only: [:index]
  mount ActionCable.server => '/cable'
end
