module ApplicationHelper

  def get_key (key)
    case key
    when 'alert'
      "danger"
    when 'notice'
      "success"
    else
      key
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
