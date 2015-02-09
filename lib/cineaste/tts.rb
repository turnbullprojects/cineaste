require 'httparty'

class Cineaste::TTS

  VOICE_F = "female"
  VOICE_M = "male"

  def initialize(word, voice)
    @voice = voice 
    @word = word
  end

  def get_word
    if @voice == VOICE_F
      download = tts_female_voice
    else
      download = tts_male_voice
    end
    return save_audio
  end

  def save_audio(download)
    @s3 = Aws::S3::Client.new
    @s3.put_object(bucket: S3_BUCKET, key: "#{AUDIO_ROOT}/#{@voice}/#{@word}.mp3", body: download)
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
    return res.parsed_response
  end

  def tts_male_voice
    url = "http://tts-api.com/tts.mp3"
    options = { q: "#{@word}" }    
    res = HTTParty.get(url, query: options)
    return res.parsed_response
  end


end
