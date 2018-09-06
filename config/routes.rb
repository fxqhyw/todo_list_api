Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :projects do
        resources :tasks, only: %i[index create]
      end
      resources :tasks, only: %i[show update destroy] do
        resources :comments, only: %i[index create destroy]
        member do
          put :complete
          put :position
        end
      end
    end
  end
end
