# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root 'welcome#index'
  
  resources :channels, param: :slug
  resources :channel_sources

  resources :features

  resources :videos
  resources :video_sources
end
