class Site < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_sites
  has_one :site_configuration
end
