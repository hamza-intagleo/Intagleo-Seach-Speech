class Site < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_sites
  has_one :site_configuration

  has_many :analytics

  validates :site_name, :site_url, presence: true
  validates_uniqueness_of :site_url


  def generate_company_number
    rand.to_s[2..11] 
  end

  def fetch_stats detail_id
    case detail_id.to_i
    when 1
      analytics.where(updated_at: 24.hours.ago..Time.now).count
    when 2
      analytics.count
    when 3
      analytics
    when 4
      analytics.average(:search_reponse_time)
    when 5
      analytics.average(:text_processing_time)
    when 6
      analytics.pluck(:search_string)
    when 7
      analytics
    when 8
      analytics
    else
      analytics
    end

  end
end
