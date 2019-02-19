class SiteConfiguration < ApplicationRecord
  belongs_to :site
  has_one_attached :search_icon
end
