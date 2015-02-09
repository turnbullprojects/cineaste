require_relative 'modules/paths'
require_relative 'modules/helpers'
require_relative 'word'

class Cineaste::Phrase
  include Cineaste::Helpers
  include Cineaste::Paths

  def initialize(dictionary, phrase, voice)
    @dict = dictionary
    @phrase = sanitize(phrase)
    @encoded_phrase = Base64.urlsafe_encode64(phrase)
    @words = @phrase.split(" ")
    @voice = voice
  end


##################################################
# Main
##################################################

  def get_video
    video = get_media(phrase_path) 
    if video == nil
      video = make_phrase_video
    end
    return video
  end


##################################################
# Helpers
##################################################

  def make_phrase_video
    videos = videos_for_phrase
    return Cineaste::Encoder.concatenate(videos)
  end

  def videos_for_phrase
    videos = []
    @words.each do |entry|
      word = Cineaste::Word.new(@dict, entry, @voice)
      videos << word.find_or_create_video
    end
    return videos
  end

  def sanitize(str)
    unescaped = URI.decode(str)
    return unescaped.downcase.gsub(/[^\w\s]/,"") 
  end


end
