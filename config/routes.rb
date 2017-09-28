Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    resources :users, except: :new
    get "/auth/:provider/callback", to: "sessions#create"
    get "/auth/failure", to: "sessions#failure"
    get "/admin", to: "admin#admin"
  end
  resources :account_activations, only: :edit
  resources :password_resets, except: %i(index show destroy)
end
