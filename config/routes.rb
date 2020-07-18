Rails.application.routes.draw do
  get "/", to: redirect("/channels")
  resources :posts
  resources :channels, param: :slug
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
