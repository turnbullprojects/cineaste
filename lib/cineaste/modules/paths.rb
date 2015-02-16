module Cineaste
  module Paths
    DICTIONARY_ROOT = "resources/video/dictionaries"
    AUDIO_ROOT = "resources/audio/voice"
    TEMP_DIR = "tmp"

    def local_file(path)
      return "#{TEMP_DIR}/#{path}"
    end

    def dict_path(dict)
      "#{DICTIONARY_ROOT}/#{dict}"
    end

    def defined_video_path(dict,word)
      "#{dict_path(dict)}/defined/#{word}.mp4"
    end

    def generated_video_path(dict,word)
      "#{dict_path(dict)}/generated/#{word}.mp4"
    end

    def word_audio_path(voice,word)
      "#{AUDIO_ROOT}/#{voice}/#{word}.mp3"
    end

    def template_video_path(dict)
      "#{DICTIONARY_ROOT}/#{dict}/template/template.mp4"
    end

    def phrase_path(dict,encoded_phrase)
      "#{dict_path(dict)}/phrases/#{encoded_phrase}.mp4"
    end

  end
end
