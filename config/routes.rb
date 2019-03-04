Rails.application.routes.draw do

  
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  get 'demo' => 'home#demo', as: :demo

  post 'google_speech_to_text' => 'home#google_speech_to_text', as: :google_speech_to_text
  get 'generate_signature' => 'home#generate_signature', as: :generate_signature
  
  resources :users, only: :renew_api_keys do
    get :renew_api_keys
    resources :sites, only: :create do
      post :add_site_configuration
      get :get_site_configuration
      get :search_text_into_site
      post :convert_audio_to_text
      get :get_statistics
    end
  end


end
