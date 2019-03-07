# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  skip_before_action :verify_authenticity_token, only: [:create, :edit]
  skip_before_action :require_no_authentication, only: [:create, :edit, :update]
  
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  def create
    begin
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?

      if successfully_sent?(resource)
        respond_to do |format|
          format.html {respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))}
          format.json { 
            render json: {success: true, error: false, message: "You will receive an email with instructions on how to reset your password in a few minutes."}, status: 200
          }
        end
        
      else
        render json: {success: false, error: true, message: resource.errors.full_messages.join(', ')}, status: 422
      end
    rescue Exception => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path 
  end
end
