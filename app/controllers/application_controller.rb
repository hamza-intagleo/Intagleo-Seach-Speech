class ApplicationController < ActionController::Base


  protected
    def after_sign_in_path_for(resource)
      request.env['omniauth.origin'] || user_dashboard_path(resource) || root_path
    end
end
