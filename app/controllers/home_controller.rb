include WaveFile
class HomeController < ApplicationController


  def google_speech_to_text
    require 'base64'
    require "google/cloud/speech"
    save_path = Rails.root.join("public/audio")
    unless File.exists?(save_path)
      Dir::mkdir(Rails.root.join("public/audio"))
    end
    data=params[:audio_url]
    audio_data=Base64.decode64(data.split(',').last)
    File.open(save_path+"_audio", 'wb') do |f| f.write audio_data end

    require 'wavefile'

    files_to_append = ["public/audio/_audio"]

    Writer.new("./public//audio/converted_audio.wav", Format.new(:mono, :pcm_16, 44100)) do |writer|
      files_to_append.each do |file_name|
        Reader.new(file_name).each_buffer do |buffer|
          writer.write(buffer)
        end
      end
    end

    # ENV['GOOGLE_APPLICATION_CREDENTIALS'] = "#{Rails.root}/resources/speech_to_text.json"
    speech = Google::Cloud::Speech.new
    file_name = save_path+"converted_audio.wav"
    audio_file = File.binread file_name
    config = { encoding:          :LINEAR16,
               sample_rate_hertz: 44100,
               language_code:     "en-US"   }
    audio  = { content: audio_file }

    response = speech.recognize config, audio
    results = response.results
    
    outputs = []
    alternatives = results.present? ? results.first.alternatives : []
    if alternatives.present?
      alternatives.each do |alternative|
        outputs << "Transcription: #{alternative.transcript}"
      end

      if outputs.present?
        require 'google/apis/customsearch_v1'
        search = Google::Apis::CustomsearchV1
        search_client = search::CustomsearchService.new
        search_client.key = ENV['GOOGLE_SEARCH_API_KEY']
        # (q, c2coff: nil, cr: nil, cx: nil, date_restrict: nil, exact_terms: nil, exclude_terms: nil, file_type: nil, filter: nil, gl: nil, googlehost: nil, high_range: nil, hl: nil, hq: nil, img_color_type: nil, img_dominant_color: nil, img_size: nil, img_type: nil, link_site: nil, low_range: nil, lr: nil, num: nil, or_terms: nil, related_site: nil, rights: nil, safe: nil, search_type: nil, site_search: nil, site_search_filter: nil, sort: nil, start: nil, fields: nil, quota_user: nil, user_ip: nil, options: nil)
        # site:amazon.com i want to search for red shoes
        response = search_client.list_cses("site:#{params[:site]} #{outputs.first.split(':').last.strip}", {cx: ENV['GOOGLE_CUSTOM_SEARCH_ENGINE_ID']})
      end

      return render :json => {:success => true, :result => outputs, :search_data => response.items} 
    else
      render :json => {:success => false, :result => [], :search_data => []}
    end
  end

  def search_text_into_site
    # begin
      # @site = Site.find(params[:site_id])
      # site_analytics = @site.analytics.find(params[:analytics_id])
      require 'google/apis/customsearch_v1'
      processing_start_at = Time.now
      search = Google::Apis::CustomsearchV1
      search_client = search::CustomsearchService.new
      search_client.key = ENV['GOOGLE_SEARCH_API_KEY']
      @response = search_client.list_cses("site:#{params[:site_url]} #{params['search_string']}", {cx: ENV['GOOGLE_CUSTOM_SEARCH_ENGINE_ID']})
      processing_end_at = Time.now
      # if @response.items.present?
      #   # site_analytics.update(text_processing_time: (processing_end_at - processing_start_at))
      #   # render json: {success: true, error: false,  results: response.items}, status: 200 
      # else
      #   # render json: {success: false, error: true,  message: "Not found any thing"}, status: 404 
      # end
    # rescue => e
    #   render json: {success: false, error: true, message: e}, status: 500
    # end

  end

  def generate_signature
    require 'digest'
    api_key = params[:api_key]
    shared_secret = params[:shared_secret]
    timestamp = params[:timestamp]
    toBeHashed = "#{api_key}#{shared_secret}#{timestamp}"
    signature = Digest::SHA2.new(512).hexdigest(toBeHashed)
    render json: {success: true, error: false, authorized_signature: signature}
  end


  def convert_audio_to_text_free
    begin
      require 'base64'
      require "google/cloud/speech"

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

        Writer.new("./public//audio/converted_audio.wav", Format.new(:mono, :pcm_16, 44100)) do |writer|
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
        analytics = Analytic.create!(search_string: outputs.first.split(':').last.strip, search_reponse_time: (processing_ends_at - processing_start_at))
        return render json: {success: true, error: false,  results: outputs}, status: 200
      else
        return render json: {success: false, error: true,  message: "Audio is not recorded. Please check your mic settings"}, status: 422
      end
    rescue => e
      render json: {success: false, error: true, message: e}, status: 500
    end
  end


end
