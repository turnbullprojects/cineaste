require_relative 'modules/paths'
require_relative 'modules/helpers'

class Cineaste::Encoder
  include Cineaste::Paths

  TEMP_PATH = "~/tmp"

  def initialize
    @word = ""
    @words = ""
    @dictionary = ""
    @encoded_phrase = ""
  end

##################################################
# Main
##################################################

  def combine_video_and_audio(video,audio)
    local_video = download_video(video)
    local_audio = download_audio(audio)
    local_output = "#{TEMP_PATH}/generated/#{word}.mp4"

    # Set up FFMPEG Command
    cmd = "ffmpeg -i #{local_video} -i #{local_audio} -map 0:v -map 1:a -codec:v libx264 -preset medium -crf 23 -maxrate 400k -codec:a aac -strict experimental -ar 44100 -shortest #{local_output} -n"

    # Run FFMPEG process
    system(cmd)

    # Save it to S3
    save(local_output)
  end

  def concatenate(videos)
    local_output = "#{TEMP_PATH}/phrase/#{@encoded_phrase}.mp4"
    inputs = ""
    streams = ""
    paths.each_with_index do |path,i|
      inputs += "-i #{path} "
      if i == 0
        streams += " [#{i}:1]"
      else 
        streams += " [#{i}:0] [#{i}:1]"
      end
    end

    # Set up FFMPEG Command
    cmd = "ffmpeg #{inputs}-y -filter_complex '[0:0] setsar=1/1[sarfix];[sarfix]#{streams} concat=n=#{paths.count}:v=1:a=1[v] [a]' -map '[v]' -map '[a]' -strict -2 -acodec aac -b:a 128k -vcodec libx264 -pix_fmt yuv420p -aspect 4:3 -threads 4 -b:v 2400k -partitions +parti4x4+partp8x8+partb8x8 -mixed-refs 1 -subq 6 -b_strategy 2 #{local_output}"  

    # Run the FFMPEG process
    system(cmd)

    # Save output to S3
    save(local_output)
  end

##################################################
# Helpers
##################################################

  def save(video)
    @s3 = Aws::S3::Client.new
    @s3.put_object(bucket: s3_bucket, key: generated_word_path, body: video)
  end

  def download_video(video)
    url = s3_url(video)
    res = HTTParty.get(url)
    return res.parsed_response
  end

  def download_audio(audio)
    url = s3_url(video)
    res = HTTParty.get(url)
    return res.parsed_response
  end

end
