require_relative 'modules/paths'
require_relative 's3_client'
require_relative 'word'

module Cineaste
  class Phrase
    include Paths

    def initialize(dictionary, phrase, voice)
      @dict = dictionary
      @phrase = sanitize(phrase)
      @encoded_phrase = Base64.urlsafe_encode64(phrase)
      @words = @phrase.split(" ")
      @voice = voice
      @s3 = S3Client.new
    end


    ##################################################
    # Main
    ##################################################

    def get_video
      video = @s3.get_url(phrase_path(@dict, @encoded_phrase)) 
      if video == nil
        make_phrase_video
        video = @s3.get_url(phrase_path(@dict, @encoded_phrase)) 
      end
      return video
    end


    ##################################################
    # Helpers
    ##################################################

    def make_phrase_video
      videos = videos_for_phrase
      path = phrase_path(@dict, @encoded_phrase)
      Encoder.concatenate(videos, path)
    end

    def videos_for_phrase
      videos = []
      @words.each do |entry|
        word = Word.new(@dict, entry, @voice)
        videos << word.find_or_create_video
      end
      return videos
    end

    def sanitize(str)
      unescaped = URI.decode(str)
      return unescaped.downcase.gsub(/[^\w\s]/,"") 
    end


  end
end
