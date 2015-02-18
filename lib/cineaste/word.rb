require_relative 'modules/paths'
require_relative 'encoder'
require_relative 'tts'
require_relative 's3_client'

module Cineaste
  class Word
    include Paths

    def initialize(dictionary, word, voice)
      @dict = dictionary
      @word = word
      @voice = voice
      @s3 = S3Client.new
    end

    ##################################################
    # Main
    ##################################################

    def find_or_create_video
      video = get_saved_video
      if video == nil 
        puts "No saved video found"
        video = generate_video 
      end
      return video
    end


    ##################################################
    # Helpers
    ##################################################

    def get_saved_video
      puts "searching for #{defined_video_path(@dict,@word)}"
      @s3.get_media(defined_video_path(@dict,@word)) || @s3.get_media(generated_video_path(@dict,@word))
    end

    def generate_video
      audio = find_or_create_audio
      template = @s3.get_media(template_video_path(@dict))
      path = generated_video_path(@dict,@word)
      local_path = local_file(path)
      if template != nil
        Cineaste::Encoder.combine_video_and_audio(template,audio,path)
        return local_path
      else
        raise StandardError, "No template video found"
      end
    end

    def find_or_create_audio
      path = word_audio_path(@voice, @word)
      audio = @s3.get_media(path)
      if audio == nil
        tts = Cineaste::TTS.new(@word, @voice)
        tts.get_word
        audio = @s3.get_media(path)
      end
      return audio
    end



  end
end
