Rails.application.routes.draw do

  concern :reactionable do
    resources :reactions, only: [:create, :destroy] do
      member do
        patch :like
        patch :dislike
      end
    end
  end

  devise_for :users

  root to: 'questions#index'

  resources :questions, concerns: :reactionable do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: :reactionable do
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
