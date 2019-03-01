include WaveFile
class HomeController < ApplicationController

  swagger_controller :sites, 'User Authorization'

  swagger_api :generate_signature do |api| 
    summary 'Generate signature that can be used for API calls'

    param :header, 'client_api', :string, :required, "Cleint API Key"
    param :header, 'client_secret', :string, :required, "Client Secret Key"
  end

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

  def generate_signature
    require 'digest'
    api_key = params[:api_key]
    shared_secret = params[:shared_secret]
    toBeHashed = "#{api_key}#{shared_secret}"
    signature = Digest::SHA2.new(512).hexdigest(toBeHashed)
    render json: {success: true, error: false, authorized_signature: signature}
  end


end
