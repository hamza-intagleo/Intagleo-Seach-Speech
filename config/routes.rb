Rails.application.routes.draw do

  Rails.application.routes.draw do
    devise_for :users, controllers: {
      sessions: 'users/sessions',
      registrations: 'users/registrations',
      passwords: 'users/passwords'
    }
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  post 'google_speech_to_text' => 'home#google_speech_to_text', as: :google_speech_to_text

  resources :users, only: :renew_api_keys do
    get :renew_api_keys
    resources :sites, only: :create do
      post :add_site_configuration
    end
  end


end
