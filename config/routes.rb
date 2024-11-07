Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :make_best
      end
    end
  end

  root to: 'questions#index'
end
