Rails.application.routes.draw do

  resources :reactions, only: [] do
    patch :like, on: :collection
    patch :dislike, on: :collection
  end

  devise_for :users

  root to: 'questions#index'

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :make_best
      end
    end
  end

  resources :users, only: [] do
    member do
      get :rewards
    end
  end

  resources :attachments, only: :destroy
end
