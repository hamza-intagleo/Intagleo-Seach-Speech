class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # has_and_belongs_to_many :sites, :join_table => :users_sites
  has_many :sites
  belongs_to :plan, dependent: :destroy
  after_create :assign_default_role

  validate :password_complexity

  def password_complexity
    if password.present? and not password.match("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{6,}$")
      errors.add :password, "must include at least one lowercase letter, one uppercase letter, and one number"
    end
  end

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

  def has_free_plan?
    plan_id != nil && plan_id == 1
  end

  def has_basic_plan?
    plan_id != nil && plan_id == 2
  end

  def has_standard_plan?
    plan_id != nil && plan_id == 3
  end

  def has_enterprise_plan?
    plan_id != nil && plan_id == 4
  end

  def has_plan?
    plan_id != nil
  end

  def create_subscription!(token, plan_id)
    customer = message = nil 
    begin
      customer = Stripe::Customer.create(
        :source => token, # obtained from Stripe
        :plan => plan_id,
        :email => email
      )
      
    rescue => e
      errors.add(:credit_card, e.message)
      message = e.message
    end
    {customer: customer, message: message }
  end

  def save_subscription_details!(stripe_token, customer_id, sub_id, trial_end_date, plan_id, is_plan_confirm)
    active_until = (plan_id == '01' ? (Time.now.utc + 2.weeks) : (Time.now.utc + 1.month))
    update_columns(stripe_token: stripe_token,
                  customer_id: customer_id,
                  subscription_id: sub_id,
                  active_until: active_until,
                  plan_id: plan_id,
                  is_plan_confirm: is_plan_confirm)
  end
end
