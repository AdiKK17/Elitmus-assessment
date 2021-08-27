Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :advertisement
    resources :comment
    resources :user
    post "/user/login", to: "user#login"

  end
end