Rails.application.routes.draw do
  root "application#status"

  resources :employees do
    collection do
      get :top
    end
    member do
      post :resign
    end
  end
end
