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

    alternatives = results.first.alternatives
    alternatives.each do |alternative|
      outputs << "Transcription: #{alternative.transcript}"
    end

    if outputs.present?
      require 'google/apis/customsearch_v1'
      search = Google::Apis::CustomsearchV1
      search_client = search::CustomsearchService.new
      search_client.key = ENV['GOOGLE_SEARCH_API_KEY']
      # (q, c2coff: nil, cr: nil, cx: nil, date_restrict: nil, exact_terms: nil, exclude_terms: nil, file_type: nil, filter: nil, gl: nil, googlehost: nil, high_range: nil, hl: nil, hq: nil, img_color_type: nil, img_dominant_color: nil, img_size: nil, img_type: nil, link_site: nil, low_range: nil, lr: nil, num: nil, or_terms: nil, related_site: nil, rights: nil, safe: nil, search_type: nil, site_search: nil, site_search_filter: nil, sort: nil, start: nil, fields: nil, quota_user: nil, user_ip: nil, options: nil)
      response = search_client.list_cses("#{outputs.first.split(':').last.strip}", {cx: ENV['GOOGLE_CUSTOM_SEARCH_ENGINE_ID'], site_search: 'nike.com'})
    end

  return render :json => {:success => true, :result => outputs, :search_data => response.items} 
  end


end
