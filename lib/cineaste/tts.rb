require 'httparty'
require_relative 'modules/paths'
require_relative 's3_client'

module Cineaste
  class TTS
    include Paths

    VOICE_F = "female"
    VOICE_M = "male"

    def initialize(word, voice)
      @voice = voice 
      @word = word
      @s3 = S3Client.new
    end

    def get_word
      if @voice == VOICE_F
        download = tts_female_voice
      else
        download = tts_male_voice
      end
      return save_audio(download)
    end

    def save_audio(download)
      path = word_audio_path(@voice,@word)
      @s3.save(path)
    end

    def tts_female_voice
      url = "http://translate.google.com/translate_tts"
      options = {
        ie: "UTF-8",
        tl: "en",
        q: "#{@word}",
        textlen: "#{@word.length}"
      }
      res = HTTParty.get(url, query: options)
      path = word_audio_path(@voice,@word)
      f = File.open(local_file(path), "w")
      f.write res.parsed_response
      f.close   
    end

    def tts_male_voice
      url = "http://tts-api.com/tts.mp3"
      options = { q: "#{@word}" }    
      res = HTTParty.get(url, query: options)
      path = word_audio_path(@voice,@word)
      f = File.open(local_file(path), "w")
      f.write res.parsed_response
      f.close
    end


  end
end
