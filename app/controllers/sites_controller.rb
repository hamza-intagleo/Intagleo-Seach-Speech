class SitesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :add_site_configuration, :convert_audio_to_text]
  # before_action :verify_client, only: [:search_text_into_site, :convert_audio_to_text, :get_statistics]

  
  def new
    @user = User.find(params[:user_id])
    @site = @user.sites.new
  end

  def edit
    @user = User.find(params[:user_id])
    @site = @user.sites.find(params[:id])
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
        @user.update(status: 'active')
        respond_to do |format|
          format.html {
            redirect_to user_configuration_path(@user), notice: "Site is successfully added"
          }
          format.json { 
            render json: {success: true, error: false, message: "Site is successfully added", results: @site}, status: 200
          }
        end
      else
        respond_to do |format|
          format.html {redirect_to user_configuration_path(@user), alert: "#{@site.errors.full_messages.join(', ')}"}
          format.json { 
            render json: {success: false, error: true, message: @site.errors.full_messages.join(', ')}, status: 422
          }
        end
      end
    rescue Exception => e
      respond_to do |format|
        format.html {redirect_to user_configuration_path(@user), alert: "#{e}"}
        format.json { 
          render json: {success: false, error: true, message: e}, status: 500
        }
      end
    end
  end

  def update
    begin
      @user = User.find(params[:user_id])
      @site = @user.sites.find(params[:id])

      if @site.update(site_params)
        respond_to do |format|
          format.html {
            redirect_to user_configuration_path(@user), notice: "Site is successfully updated"
          }
          format.json { 
            render json: {success: true, error: false, message: "Site is successfully updated", results: @site}, status: 200
          }
        end
      else
        respond_to do |format|
          format.html {redirect_to user_configuration_path(@user), alert: "#{@site.errors.full_messages.join(', ')}"}
          format.json { 
            render json: {success: false, error: true, message: @site.errors.full_messages.join(', ')}, status: 422
          }
        end
      end
    rescue Exception => e
      respond_to do |format|
        format.html {redirect_to user_configuration_path(@user), alert: "#{e}"}
        format.json { 
          render json: {success: false, error: true, message: e}, status: 500
        }
      end
    end
  end

  def destroy
    begin
      @user = User.find(params[:user_id])
      @site = @user.sites.find(params[:id])

      if @site.destroy
        respond_to do |format|
          format.html {
            redirect_to user_configuration_path(@user), notice: "Site is successfully destroyed"
          }
          format.json { 
            render json: {success: true, error: false, message: "Site is successfully destroyed", results: @site}, status: 200
          }
        end
      else
        respond_to do |format|
          format.html {redirect_to user_configuration_path(@user), alert: "#{@site.errors.full_messages.join(', ')}"}
          format.json { 
            render json: {success: false, error: true, message: @site.errors.full_messages.join(', ')}, status: 422
          }
        end
      end
    rescue Exception => e
      respond_to do |format|
        format.html {redirect_to user_configuration_path(@user), alert: "#{e}"}
        format.json { 
          render json: {success: false, error: true, message: e}, status: 500
        }
      end
    end

  end

  
  def site_configuration_form
    @user = User.find params[:user_id]
    @site = @user.sites.find(params[:site_id])
    @site_configuration = @site.site_configuration.present? ? @site.site_configuration : @site.build_site_configuration

  end

  def add_site_configuration
    begin
      @user = User.find(params[:user_id])
      @site = @user.sites.find(params[:site_id])
      @site_conf = @site.build_site_configuration(site_configuration_params)
      if @site_conf.save
        respond_to do |format|
          format.html {
            redirect_to user_configuration_path(@user), notice: "Site configuration is added successfully"
          }
          format.json { 
            render json: {success: true, error: false, message: "Site configuration is added successfully", results: @site_conf}, status: 200
          }
        end
      else
        respond_to do |format|
          format.html {
            redirect_to user_site_site_configuration_form_path(user_id: @user.id, site_id: @site.id), alert: "#{@site_conf.errors.full_messages.join(', ')}"
          }
          format.json { 
            render json: {success: false, error: true, message: @site_conf.errors.full_messages.join(', ')}, status: 422
          }
        end
      end
    rescue Exception => e
      respond_to do |format|
          format.html {
            redirect_to user_site_site_configuration_form_path(user_id: @user.id, site_id: @site.id), alert: e
          }
          format.json { 
            render json: {success: false, error: true, message: e}, status: 500
          }
        end

    end
  end

  def update_site_configuration
  begin
    @user = User.find(params[:user_id])
    @site = @user.sites.find(params[:site_id])
    @site_conf = @site.site_configuration
    if @site_conf.update(site_configuration_params)
      render_options = params[:render_options]
      if render_options == 'return_results_on_rendered_page'
        @site_conf.update(return_results_on_rendered_page: true, return_results_on_customer_webpage: false)
      else
        @site_conf.update(return_results_on_rendered_page: false, return_results_on_customer_webpage: true)
      end
      respond_to do |format|
        format.html {
          redirect_to user_configuration_path(@user), notice: "Site configuration is updated successfully"
        }
        format.json { 
          render json: {success: true, error: false, message: "Site configuration is updated successfully", results: @site_conf}, status: 200
        }
      end
    else
      respond_to do |format|
        format.html {
          redirect_to user_site_site_configuration_form_path(user_id: @user.id, site_id: @site.id), alert: "#{@site_conf.errors.full_messages.join(', ')}"
        }
        format.json { 
          render json: {success: false, error: true, message: @site_conf.errors.full_messages.join(', ')}, status: 422
        }
      end
    end
  rescue Exception => e
    respond_to do |format|
        format.html {
          redirect_to user_site_site_configuration_form_path(user_id: @user.id, site_id: @site.id), alert: e
        }
        format.json { 
          render json: {success: false, error: true, message: e}, status: 500
        }
      end

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

  
  def convert_audio_to_text
    begin
      require 'base64'
      require "google/cloud/speech"

      @site = Site.find(params[:site_id])
      
      
      if params[:audio_url].present?

        save_path = Rails.root.join("public/audio")
        unless File.exists?(save_path)
          Dir::mkdir(Rails.root.join("public/audio"))
        end

        data=params[:audio_url]

        audio_data=Base64.decode64(data.split(',').last)
        File.open(save_path+"_audio", 'wb') do |f| f.write audio_data end

        require 'wavefile'

        files_to_append = ["public/audio/_audio"]

        Writer.new("./public/audio/converted_audio.wav", Format.new(:mono, :pcm_16, 44100)) do |writer|
          files_to_append.each do |file_name|
            Reader.new(file_name).each_buffer do |buffer|
              writer.write(buffer)
            end
          end
        end
        file_name = save_path+"converted_audio.wav"
      else
        file_name = params[:audio_file].tempfile
      end

      # ENV['GOOGLE_APPLICATION_CREDENTIALS'] = "#{Rails.root}/resources/speech_to_text.json"
      processing_start_at = Time.now
      speech = Google::Cloud::Speech.new
      audio_file = File.binread file_name
      config = { encoding:          :LINEAR16,
                 sample_rate_hertz: 44100,
                 language_code:     "en-US"   }
      audio  = { content: audio_file }

      response = speech.recognize config, audio
      results = response.results
      processing_ends_at = Time.now
        
      outputs = []
      alternatives = results.present? ? results.first.alternatives : []
      if alternatives.present?
        alternatives.each do |alternative|
          outputs << "Transcription: #{alternative.transcript}"
        end
      end
      if outputs.present?
        analytics = @site.analytics.create!(search_string: outputs.first.split(':').last.strip, search_reponse_time: (processing_ends_at - processing_start_at))
        return render json: {success: true, error: false,  results: outputs, analytics_id: analytics.id}, status: 200
      else
        return render json: {success: false, error: true,  message: "Audio is not valid"}, status: 422
      end
    rescue => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end

  def search_text_into_site
    begin
      @site = Site.find(params[:site_id])
      site_analytics = @site.analytics.find(params[:analytics_id])
      require 'google/apis/customsearch_v1'
      processing_start_at = Time.now
      search = Google::Apis::CustomsearchV1
      search_client = search::CustomsearchService.new
      search_client.key = ENV['GOOGLE_SEARCH_API_KEY']
      response = search_client.list_cses("site:#{@site.site_url} #{params['search_string']}", {cx: ENV['GOOGLE_CUSTOM_SEARCH_ENGINE_ID']})
      processing_end_at = Time.now
      if response.items.present?
        site_analytics.update(text_processing_time: (processing_end_at - processing_start_at))
        render json: {success: true, error: false,  results: response.items}, status: 200 
      else
        render json: {success: false, error: true,  message: "Not found any thing"}, status: 404 
      end
    rescue => e
      render json: {success: false, error: true, message: e}, status: 500
    end

  end

  def get_statistics
    begin
      @site = Site.find(params[:site_id])
      detail_id = params[:detail_id]

      stats = @site.fetch_stats(detail_id)
      

      if stats.present?
        render json: {success: true, error: false, message: "", results: stats}, status: 200
      else
        render json: {success: false, error: true, message: "No Statistics Found"}, status: 422
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
    params.permit(:site_id, :return_results_on_rendered_page, :return_results_on_customer_webpage, :custom_search_results_url, :widget_fill_color, :widget_border_color, :widget_shape, :widget_fill_color_hover, :widget_icon_color, :widget_icon_color_hover, :widget_fill_color_active, :widget_icon_color_active, :widget_border_color_active, :widget_placeholder_text, :widget_placeholder_text_color, :widget_text_border_color)
  end

  def verify_client
    begin
      if request.headers['HTTP_API_KEY'].present? && request.headers['HTTP_SIGNATURE'].present? && request.headers['HTTP_TIMESTAMP']
        require 'digest'
        api_key = request.headers['HTTP_API_KEY']
        timestamp = request.headers['HTTP_TIMESTAMP']
        user = User.find_by(client_key: api_key)
        if user.present?
          shared_secret = user.client_secret
          toBeHashed = "#{api_key}#{shared_secret}#{timestamp}"
          signature = Digest::SHA2.new(512).hexdigest(toBeHashed)
          unless signature == request.headers['HTTP_SIGNATURE']
            render json: {success: false, error: true, message: "Not Authorised!"}, status: 404
          end
        else
          render json: {success: false, error: true, message: "Not a Valid API key"}, status: 401
        end
      else
        render json: {success: false, error: true, message: "Missing authorization headers"}, status: 404
      end
    rescue => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end
end
