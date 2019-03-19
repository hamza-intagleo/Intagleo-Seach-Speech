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
end
