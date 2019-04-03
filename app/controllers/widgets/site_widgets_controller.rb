class Widgets::SiteWidgetsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :set_site_parameter

  def search_widget
    configuration = @site.site_configuration
    @return_results_on_rendered_page = configuration.return_results_on_rendered_page
    @return_results_on_customer_webpage = configuration.return_results_on_customer_webpage
    @custom_search_results_url = configuration.custom_search_results_url
    @search_icon_color = configuration.search_icon_color
    @search_icon_text = configuration.search_icon_text
    @search_box_size = configuration.search_box_size
    @search_box_shape = configuration.search_box_shape
    @search_box_fill_color = configuration.search_box_fill_color
    @search_box_border_color = configuration.search_box_border_color
    @search_box_placeholder_text = configuration.search_box_placeholder_text

  end


  def set_site_parameter
    @site = Site.find params[:site_id]
  end
end