class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  def generate_api_keys
    api_key = SecureRandom.urlsafe_base64
    secret_key = Base64.encode64("#{self.email}, #{api_key}, #{Time.now}")
    self.update!(client_key: api_key, client_secret: secret_key)
  end
end
