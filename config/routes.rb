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
  post 'contact_us' => 'home#contact_us', as: :contact_us
  get 'users/pricing'
  post 'customer' => 'subscriptions#create_customer', as: :customer

  post 'google_speech_to_text' => 'home#google_speech_to_text', as: :google_speech_to_text
  get 'generate_signature' => 'home#generate_signature', as: :generate_signature
  get 'search_text_into_site' => 'home#search_text_into_site', as: :search_text_into_site
  post 'convert_audio_to_text_free' => 'home#convert_audio_to_text_free', as: :convert_audio_to_text_free
  resources :users, only: :renew_api_keys do
    get :renew_api_keys
    resources :sites do
      post :add_site_configuration
      get :get_site_configuration
      get :site_configuration_form
      post :update_site_configuration
      # get :search_text_into_site
      post :convert_audio_to_text
      get :get_statistics
    end
  end

  resources :users, only: :dashboard do
    get :dashboard
    get :configuration
    get :api
    get :widgets
    get :contact_us
    get :subscription
  end

  namespace :widgets do
    resources :site_widgets, only: [] do
      collection do
        get :site
        get :site_widget
      end
    end
  end

  


end
