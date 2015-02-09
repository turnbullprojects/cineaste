module Cineaste::Paths
  DICTIONARY_ROOT = "resources/video/dictionaries"
  AUDIO_ROOT = "resources/audio/voice"

  def dict_path
    "#{DICTIONARY_ROOT}/#{@dict}"
  end

  def defined_word_path
    "#{dict_path}/defined/#{@word}.mp4"
  end

  def generated_word_path
    "#{dict_path}/generated/#{@word}.mp4"
  end

  def word_audio_path
    "#{AUDIO_ROOT}/#{@voice}/#{@word}.mp3"
  end

  def template_video_path
    "#{DICTIONARY_ROOT}/#{@dict}/template/template.mp4"
  end

  def phrase_path
    "#{dict_path}/phrases/#{@encoded_phrase}.mp4"
  end

end
