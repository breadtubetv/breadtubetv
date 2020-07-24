# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

Rails.application.routes.draw do
  resources :channel_supports
  resources :channel_socials
  root 'pages#home'
  get 'privacy', to: 'pages#privacy'
  get 'peertube', to: redirect('https://watch.breadtube.tv/')
  get 'youtube', to: redirect('https://www.youtube.com/channel/UCv8O1dx5UjWHlJuo_Wl6o5w')

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
