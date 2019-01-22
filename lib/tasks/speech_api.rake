namespace :speech_api do
  desc "TODO"
  task google_speech_api: :environment do
    # Imports the Google Cloud client library
    require "google/cloud/speech"

    # Instantiates a client
    ENV['GOOGLE_APPLICATION_CREDENTIALS'] = "#{Rails.root}/resources/speech_to_text.json"
    speech = Google::Cloud::Speech.new

    # The name of the audio file to transcribe
    file_name = "./resources/append.wav"

    # The raw audio
    audio_file = File.binread file_name

    # The audio file's encoding and sample rate
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
    #   puts "Transcription: #{alternatives.transcript}"
    # end

    alternatives = results.first.alternatives
    alternatives.each do |alternative|
      puts "Transcription: #{alternative.transcript}"
    end
  end

  task stereo_to_mono: :environment do
    require 'wavefile'
    include WaveFile

    FILES_TO_APPEND = ["./resources/helloo.wav"]

    Writer.new("./resources/append.wav", Format.new(:mono, :pcm_16, 44100)) do |writer|
      FILES_TO_APPEND.each do |file_name|
        Reader.new(file_name).each_buffer do |buffer|
          writer.write(buffer)
        end
      end
    end
  end
end
