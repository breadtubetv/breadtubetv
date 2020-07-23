# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  root 'pages#home'
  
  resources :features

  resources :channel_sources
  resources :video_sources

  resources :channels, only: [:index, :new, :create]
  resources :videos, only: [:index, :new, :create]

  resources :channels, path: '/', except: [:index, :new, :create] do
    member do
      get :sync, :edit # fixes the video path taking over
    end
    resources :videos, path: '/', except: [:index, :new, :create] do
      member do
        get :sync
      end
    end
  end
end
