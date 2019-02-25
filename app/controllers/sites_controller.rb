class SitesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :add_site_configuration]
  before_action :verify_client, only: [:search_text_into_site]

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
    param :query, "custom_search_results_url", :integer, :optional, "Search String Url"
    param :query, "search_icon_color", :string, :optional, "Search Icon Color"
    param :query, "search_icon_text", :text, :optional, "Search Icon Text"
    param :query, "search_box_shape", :string, :optional, "Search Box Shape"
    param :query, "search_box_fill_color", :string, :optional, "Search Box Fill Color"
    param :query, "search_box_border_color", :string, :optional, "Search Box Border Color"
    param :query, "search_box_placeholder_text", :text, :optional, "Search Box Placeholder Text"
  end

  swagger_api :get_site_configuration do |api| 
    summary 'Get Site Configuration'

    param :path, :user_id, :integer, :required, "User ID"
    param :path, :site_id, :integer, :required, "Site ID"
  end

  swagger_api :search_text_into_site do |api| 
    summary 'Search Text In Site'
    param :header, 'client_api', :string, :required, "Cleint API Key"
    param :header, 'client_secret', :string, :required, "Client Secret Key"
    param :path, :user_id, :integer, :required, "User ID"
    param :path, :site_id, :integer, :required, "Site ID"
    param :query, "search_string", :string, :required, "Search String"
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

  def get_site_configuration
    begin
      @site = Site.find(params[:site_id])
      @site_conf = @site.site_configuration
      if @site_conf.present?
        render json: {success: true, error: false, message: "", results: @site_conf}, status: 200
      else
        render json: {success: false, error: true, message: "Site configuration not found for the site"}, status: 422
      end
    rescue => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end

  def search_text_into_site
    begin
      @site = Site.find(params[:site_id])
      require 'google/apis/customsearch_v1'
      search = Google::Apis::CustomsearchV1
      search_client = search::CustomsearchService.new
      search_client.key = ENV['GOOGLE_SEARCH_API_KEY']
      response = search_client.list_cses("site:#{@site.site_url} #{params['search_string']}", {cx: ENV['GOOGLE_CUSTOM_SEARCH_ENGINE_ID']})
      if response.items.present?
        render json: {success: true, error: false,  results: response.items}, status: 200 
      else
        render json: {success: false, error: true,  message: "Not found any thing"}, status: 404 
      end
    rescue => e
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

  def verify_client
    begin
      @user = User.find params[:user_id]
      if request.headers['HTTP_CLIENT_KEY'].present? && request.headers['HTTP_CLIENT_SECRET'].present?
        unless request.headers['HTTP_CLIENT_KEY'] == @user.client_key && request.headers['HTTP_CLIENT_SECRET'] == @user.client_secret
          render json: {success: false, error: true, message: "Not Authorised!"}, status: 404
        end
      else
        render json: {success: false, error: true, message: "Missing authorization headers"}, status: 404
      end
    rescue => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end
end
