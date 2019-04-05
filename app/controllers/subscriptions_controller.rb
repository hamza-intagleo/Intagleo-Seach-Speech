require 'json'
class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_plan, only: [:create_customer]


  def create_customer
    subscription = current_user.create_subscription!(params[:stripe_token], @plan.stripe_id)
    if subscription[:customer].present?
      customer = subscription[:customer]
      current_user.save_subscription_details!( params[:stripe_token], 
                                         customer['id'], 
                                         customer['subscriptions']['data'].first['id'], 
                                         customer['subscriptions']['data'].first['current_period_end'],
                                         @plan.id,
                                         true
                                        )
      location_path = (!current_user.is_plan_confirm ? users_pricing_path : (current_user.status == 'inactive' ? user_configuration_path(current_user) : user_dashboard_path(current_user, search_type: 'all'))) || root_path
      return render :json => { :success => true, location_path: location_path}
    else
      return render :json => { :success => false, message: subscription[:message], location_path: users_pricing_path}
    end  
  end

  private

  def set_plan
    if !current_user.has_plan? || params[:plan].present?
      @plan = Plan.find_by_id(params[:plan])
    else
      @plan = current_user.plan
    end
    if !@plan.present?
      return render :json => { :success => false }
    end
  end
end
