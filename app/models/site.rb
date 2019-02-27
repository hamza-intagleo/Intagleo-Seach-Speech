class Site < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_sites
  has_one :site_configuration

  has_many :analytics

  validates :site_name, :site_url, presence: true
  validates_uniqueness_of :site_url


  def generate_company_number
    rand.to_s[2..11] 
  end
end
