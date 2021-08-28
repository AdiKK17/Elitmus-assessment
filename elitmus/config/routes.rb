Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :advertisement
    get "/relevantAds/:id", to: "advertisement#getRelevantAds"
    get "/getPublishedAds", to: "advertisement#getPublishedAds"
    get "/myAds/:id", to: "advertisement#myAds"
    resources :comment
    resources :user
    post "/user/login", to: "user#login"

  end
end