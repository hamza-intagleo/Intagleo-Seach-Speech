class Widgets::SiteWidgetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_site_parameter

  def search_widget
    configuration = @site.site_configuration
    @return_results_on_rendered_page = configuration.return_results_on_rendered_page
    @return_results_on_customer_webpage = configuration.return_results_on_customer_webpage
    @custom_search_results_url = configuration.custom_search_results_url

    @widget_fill_color = configuration.widget_fill_color
    @widget_border_color = configuration.widget_border_color
    @widget_shape = configuration.widget_shape
    @widget_fill_color_hover = configuration.widget_fill_color_hover
    @widget_icon_color = configuration.widget_icon_color
    @widget_icon_color_hover = configuration.widget_icon_color_hover
    @widget_fill_color_active = configuration.widget_fill_color_active

    @widget_icon_color_active = configuration.widget_icon_color_active
    @widget_border_color_active = configuration.widget_border_color_active
    @widget_placeholder_text = configuratiowidget_placeholder_textve
    @widget_placeholder_text_color = configuratiowidget_placeholder_text_color
    @widget_text_border_color = configuration.widget_text_border_color
    

  end


  def set_site_parameter
    @site = Site.find params[:site_id]
  end
end