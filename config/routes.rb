Rails.application.routes.draw do
  apipie
  devise_for :users, controllers: { sessions: 'api/v1/sessions' }
  namespace :api, { defaults: { format: :json } } do
    namespace :v1 do
      resources :sessions
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :projects do
        resources :tasks, only: %i[index create]
      end
      resources :tasks, only: %i[show update destroy] do
        resources :comments, only: %i[index create]
        member do
          patch :complete
          patch :position
        end
      end
      resources :comments, only: %i[destroy]
    end
  end
end
