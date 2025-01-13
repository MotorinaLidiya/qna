Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  resources :reactions, only: [] do
    patch :like, on: :collection
    patch :dislike, on: :collection
  end

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    omniauth_callbacks: 'oauth_callbacks'
  }

  devise_scope :user do
    post 'users/email_confirmation', to: 'oauth_callbacks#confirm_email', as: :confirm_email
  end

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
