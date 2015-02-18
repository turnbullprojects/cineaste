require_relative 'modules/paths'
require_relative 's3_client'

module Cineaste
  class Encoder
    include Paths
    attr_accessor :word, :dictionary
    @@s3 = S3Client.new

    ##################################################
    # Main
    ##################################################

    def self.combine_video_and_audio(video,audio,path)
      local_output = "#{S3Client::TEMP_DIR}/#{path}"

      # Set up FFMPEG Command
      cmd = "ffmpeg -i #{video} -i #{audio} -map 0:v -map 1:a -codec:v libx264 -preset medium -crf 23 -maxrate 400k -codec:a aac -strict experimental -ar 44100 -shortest #{local_output} -n"

      # Run FFMPEG process
      system(cmd)

      # Save it to S3Client
      @@s3.save(path)
      return @@s3.get_url(path)
    end

    def self.concatenate(videos,path)

      local_output = "#{S3Client::TEMP_DIR}/#{path}"
      inputs = ""
      streams = ""
      videos.each_with_index do |vid,i|
        inputs += "-i #{vid} "
        if i == 0
          streams += " [#{i}:1]"
        else 
          streams += " [#{i}:0] [#{i}:1]"
        end
      end

      # Set up FFMPEG Command
      cmd = "ffmpeg #{inputs}-y -filter_complex '[0:0] setsar=1/1[sarfix];[sarfix]#{streams} concat=n=#{videos.count}:unsafe=1:v=1:a=1[v] [a]' -map '[v]' -map '[a]' -strict -2 -acodec aac -b:a 128k -vcodec libx264 -pix_fmt yuv420p -aspect 4:3 -threads 4 -b:v 2400k -partitions +parti4x4+partp8x8+partb8x8 -mixed-refs 1 -subq 6 -b_strategy 2 #{local_output}"  

      # Run the FFMPEG process
      system(cmd)
      
      # Save output to S3Client
      @@s3.save(path)
    end

    def self.create_webm(path)
      mp4_path = "#{S3Client::TEMP_DIR}/#{path}"      
      webm_path = path.gsub("mp4","webm")
      local_output = "#{S3Client::TEMP_DIR}/#{webm_path}"

      cmd = "ffmpeg -i #{mp4_path} -codec:v libvpx -quality good -cpu-used 3 -b:v 500k -qmin 10 -qmax 42 -maxrate 500k -bufsize 1000k -threads 4 -vf scale=-1:480 -codec:a libvorbis -b:a 128k #{local_output}"
      system(cmd)
      @@s3.save(webm_path)
    end

  end
end
