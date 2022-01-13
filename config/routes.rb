Rails.application.routes.draw do
  get "home/index"
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  post "auth/login", "auth#login"
  get "auth/profile", "auth#profile"
  delete "auth/logout", "auth#logout"
end
