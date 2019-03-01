# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  swagger_api :update do
    summary "Updates the existing User"
    param :path, :user_id, :integer, :required, "User Id"
    param :form, "user[first_name]", :string, :optional, "First name"
    param :form, "user[last_name]", :string, :optional, "Last name"
    param :form, "user[email]", :string, :optional, "Email address"
    param :form, "user[contact_number]", :string, :optional, "Contact number"
    param :form, "user[password]", :string, :optional, "Password"
    param :form, "user[current_password]", :string, :required, "Current Password"
  end

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    begin
      build_resource(configure_sign_up_params)
      api_key, secret_key = resource.generate_api_keys
      resource.client_key = api_key
      resource.client_secret = secret_key
      resource.save
      if resource.persisted?
        if resource.active_for_authentication?
          # set_flash_message! :notice, :signed_up
          # To avoid login comment out sign_up method
          # sign_up(resource_name, resource)
          render json: {success: true, error: false, message: "User is successfully created", results: resource}, status: 200
          # render json: resource  , location: after_sign_up_path_for(resource)
        else
          # set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          render json: {success: true, error: false, message: "User is successfully created", results: resource}, status: 200
          # render json: resource # , location: after_inactive_sign_up_path_for(resource)
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        render json: {success: false, error: true, message: resource.errors.full_messages.join(', ')}, status: 422
      end
    rescue Exception => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  def update
    begin
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
      resource_updated = update_resource(resource, account_update_params)
      # yield resource if block_given?
      if resource_updated
        # set_flash_message_for_update(resource, prev_unconfirmed_email)
        bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
        render json: {success: true, error: false, message: "User is successfully updated", results: resource}, status: 200

        # respond_with resource, location: after_update_path_for(resource)
      else
        clean_up_passwords resource
        set_minimum_password_length
        render json: {success: false, error: true, message: resource.errors.full_messages.join(', ')}, status: 422
        # respond_with resource
      end
    rescue Exception => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    params[:registration].permit(:email, :password, :first_name, :last_name, :password_confirmation)
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  end

  def account_update_params
    params[:user].permit(:email, :password, :first_name, :last_name, :contact_number, :current_password)
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
