Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  post 'google_speech_to_text' => 'home#google_speech_to_text', as: :google_speech_to_text


end
