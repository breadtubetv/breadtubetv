# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root 'welcome#index'
  
  resources :features

  resources :channel_sources
  resources :video_sources

  resources :channels, only: [:index]
  resources :videos, only: [:index]

  resources :channels, path: '/', except: [:index] do
    member do
      get :sync
    end
    resources :videos, path: '/', except: [:index]
  end
end
