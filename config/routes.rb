Rails.application.routes.draw do
  root "application#status"

  resources :employees do
    collection do
      get :top
      get :search
    end
    member do
      post :resign
    end
  end
end
