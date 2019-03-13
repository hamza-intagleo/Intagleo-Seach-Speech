class UsersController < ApplicationController
  before_action :authenticate_user!, only: :dashboard
  
  def renew_api_keys
    begin
      @user = User.find(params[:user_id])
      api_key, client_secret = @user.generate_api_keys
      if @user.update!(client_key: api_key, client_secret: client_secret)
        render json: {success: true, error: false, message: "New keys are successfully generated", results: @user}, status: 200
      else
        render json: {success: false, error: true, message: @user.errors.full_messages.join(', ')}, status: 422
      end
    rescue Exception => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end

  def dashboard
  end
end