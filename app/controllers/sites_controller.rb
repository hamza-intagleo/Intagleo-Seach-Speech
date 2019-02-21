class SitesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :add_site_configuration]

  swagger_controller :sites, 'Add User Site'

  swagger_api :create do |api| 
    summary 'Add new Site'
    param :path, :user_id, :integer, :required, "User ID"
    param :query, "site[site_name]", :integer, :required, "Site Name"
    param :query, "site[site_url]", :integer, :required, "Site URL"
  end

  swagger_api :add_site_configuration do |api| 
    summary 'Add Site Configuration'

    param :path, :user_id, :integer, :required, "User ID"
    param :path, :site_id, :integer, :required, "Site ID"
    param :query, "return_results_on_rendered_page", :boolean, :required, "Return Results On Rendered Page"
    param :query, "return_results_on_customer_webpage", :boolean, :required, "Return Results On Customer Webpage"
    param :query, "search_string_url", :integer, :optional, "Search String Url"
    param :query, "search_icon_color", :string, :optional, "Search Icon Color"
    param :query, "search_icon_text", :text, :optional, "Search Icon Text"
    param :query, "search_box_shape", :string, :optional, "Search Box Shape"
    param :query, "search_box_fill_color", :string, :optional, "Search Box Fill Color"
    param :query, "search_box_border_color", :string, :optional, "Search Box Border Color"
    param :query, "search_box_placeholder_text", :text, :optional, "Search Box Placeholder Text"
  end

  def create
    begin
      @user = User.find(params[:user_id])
      @site = @user.sites.new(site_params)
      company_number = @site.generate_company_number
      while (Site.find_by(company_number: company_number).present?) do
        company_number = @site.generate_company_number
      end
      @site.company_number = company_number
      if @site.save
        render json: {success: true, error: false, message: "Site is successfully added", results: @site}, status: 200
      else
        render json: {success: false, error: true, message: @site.errors.full_messages.join(', ')}, status: 422
      end
    rescue Exception => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end

  def add_site_configuration
    begin
      @site = Site.find(params[:site_id])
      @site_conf = @site.build_site_configuration(site_configuration_params)
      if @site_conf.save
        render json: {success: true, error: false, message: "Site configuration is added successfully", results: @site_conf}, status: 200
      else
        render json: {success: false, error: true, message: @site_conf.errors.full_messages.join(', ')}, status: 422
      end
    rescue Exception => e
      render json: {success: false, error: true, message: e}, status: 500

    end
  end


  protected

  def site_params
    params[:site].permit(:site_name, :site_url)
  end

  def site_configuration_params
    params.permit(:return_results_on_rendered_page, :return_results_on_customer_webpage, :search_string_url, :search_icon_color, :search_icon_text, :search_box_size, :search_box_shape, :search_box_fill_color, :search_box_border_color, :search_box_placeholder_text)
  end
end
