Rails.application.routes.draw do

  resources :reactions, only: [] do
    patch :like, on: :collection
    patch :dislike, on: :collection
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  resources :questions do
    resources :comments, only: %i[create destroy], defaults: { commentable: 'questions' }
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :make_best
      end
      resources :comments, only:  %i[create destroy], defaults: { commentable: 'answers' }
    end
  end

  resources :users, only: [] do
    member do
      get :rewards
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
