Rails.application.routes.draw do
  resources :videos
  root 'welcome#index'
  resources :features
  resources :channels, param: :slug
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
