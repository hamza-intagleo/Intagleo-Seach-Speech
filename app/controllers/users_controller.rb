class UsersController < ApplicationController

  swagger_controller :users, 'Re-Generate API Keys'

  swagger_api :renew_api_keys do |api| 
    summary 'Renew API keys'
    param :path, :user_id, :integer, :required, "User ID"
  end

  def renew_api_keys
    @user = User.find_by(id: params[:user_id])
    if @user.present?
      api_key, client_secret = @user.generate_api_keys
      if @user.update!(client_key: api_key, client_secret: client_secret)
        render json: {success: true, error: false, message: "New keys are successfully generated", results: @user}, status: 200
      else
        render json: {success: false, error: true, message: @user.errors.full_messages.join(', ')}, status: 422
      end
    else
      render json: {success: false, error: true, message: "User Not found"}, status: 404
    end


  end
end