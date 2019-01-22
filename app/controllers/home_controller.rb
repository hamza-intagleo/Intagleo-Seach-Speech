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

    operation = speech.long_running_recognize config, audio

    puts "Operation started"

    operation.wait_until_done!

    raise operation.results.message if operation.error?

    results = operation.response.results
    # # Detects speech in the audio file
    # response = speech.recognize config, audio

    # results = response.results
    # # Get first result because we only processed a single audio file
    # # Each result represents a consecutive portion of the audio
    # results.first.alternatives.each do |alternatives|
      # puts "Transcription: #{alternatives.transcript}"
    # end
    outputs = []

    alternatives = results.first.alternatives
    alternatives.each do |alternative|
      outputs << "Transcription: #{alternative.transcript}"
    end
    
    # response = speech.recognize config, audio

    # results = response.results
    # Get first result because we only processed a single audio file
    # Each result represents a consecutive portion of the audio
    # results.first.alternatives.each do |alternatives|
    #   outputs << "Transcription: #{alternatives.transcript}"
    # end
   return render :json => {:success => true, :result => outputs} 
  end


end
