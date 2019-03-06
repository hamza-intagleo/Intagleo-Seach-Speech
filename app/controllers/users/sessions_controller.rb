# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: :create
  skip_before_action :require_no_authentication, only: :create
  # before_action :configure_sign_in_params, only: [:create]
  
  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_to do |format|
      format.html {respond_with resource, location: after_sign_in_path_for(resource)}
      format.json { 
        render json: {success: true, error: false, message: "User is successfully logged in", results: resource},  status: 200
      }
    end

    # respond_with resource, location: after_sign_in_path_for(resource)
    # begin
    #   if user_signed_in?
    #     render json: {success: false, error: true, message: "User is already Signed In"},  status: 409  
    #   else
    #     resource = User.find_by(email: params[:user][:email])
    #     if resource.present? && resource.valid_password?(params[:user][:password])
    #       # set_flash_message!(:notice, :signed_in)
    #       sign_in(resource_name, resource)
    #       # yield resource if block_given?
    #       render json: {success: true, error: false, message: "User is successfully logged in", results: resource},  status: 200
    #       # respond_with resource, location: after_sign_in_path_for(resource)
    #     else
    #       render json: {success: false, error: true, message: "Invalid user name or password"},  status: 422
    #     end
    #   end
    # rescue Exception => e
    #   render json: {success: false, error: true, message: e}, status: 500
    # end
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
