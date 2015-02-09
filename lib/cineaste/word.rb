require_relative 'modules/paths'
require_relative 'modules/helpers'
require_relative 'modules/errors'
require_relative 'encoder'
require_relative 'tts'

class Cineaste::Word
  include Cineaste::Helpers
  include Cineaste::Paths

  def initialize(dictionary, word, voice)
    @dict = dictionary
    @word = word
    @voice = voice
  end

##################################################
# Main
##################################################

  def find_or_create_video
    video = get_saved_video
    if video == nil 
      video = generate_video 
    end
    return video
  end


##################################################
# Helpers
##################################################

  def get_saved_video
    get_media(defined_video_path) || get_media(generated_video_path)
  end

  def generate_video
    encoder = word_encoder
    audio = find_or_create_audio
    template = get_media(template_video_path)
    if template != nil
      encoder.combine_video_and_audio(template,audio)
      return get_media(generated_video_path)
    else
      raise Cineaste::Errors::NoTemplateVideoFound
    end
  end

  def find_or_create_audio
    audio = get_media(audio_path)
    if audio == nil
      tts = Cineaste::TTS.new(@word, @voice)
      tts.get_word
      audio = get_media(audio_path)
    end
    return audio
  end

  def word_encoder
    encoder = Cineaste::Encoder.new
    encoder.word = @word
    encoder.dictionary = @dict
    return encoder
  end


end
