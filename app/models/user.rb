class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # has_and_belongs_to_many :sites, :join_table => :users_sites
  has_many :sites
  after_create :assign_default_role

  def generate_api_keys
    api_key = SecureRandom.urlsafe_base64

    secret_key = Base64.encode64("#{self.email}#{api_key}#{Time.now}").gsub("\n", '')
    [api_key, secret_key]
  end



  def assign_default_role
    self.add_role(:site_admin) if self.roles.blank?
  end

  def fullname
    "#{first_name} #{last_name}"
  end
end
