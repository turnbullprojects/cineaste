require_relative 'modules/paths'
require 'fileutils'
require 'aws-sdk'

module Cineaste
  class S3Client
    include Paths

    BUCKET = 'crumbles-2015'
    REGION = 'us-east-1'

    attr_accessor :client

    def initialize
      @client = @client || Aws::S3::Client.new(region: REGION)
    end

    def create_directory_if_needed(path)
      dir = File.dirname(local_file(path))
      unless File.directory?(dir)
        FileUtils.mkdir_p(dir)
      end
    end

    def get_url(path)
      if get_media(path) #check it exists, otherwise we return a path to nothing
        obj = Aws::S3::Object.new({bucket_name: BUCKET, key: path, region: REGION}) #not an api call
        return obj.public_url #returns REGARDLESS of whether obj exists in S3
      else
        return nil
      end
    end

    def get_media(path) 
      create_directory_if_needed(path)
      begin
        @client.get_object({bucket: BUCKET, key: path}, target:local_file(path) ) 
        return local_file(path)
      rescue => e 
        puts "Error for #{path}"
        puts e
        return nil
      end
    end

    def save_audio(path)
      create_directory_if_needed(path)
      @s3.save("#{Paths::AUDIO_ROOT}/#{@voice}/#{@word}.mp3")
    end


    def save(path)
      file = File.open(local_file(path), 'rb')
      @client.put_object(bucket: BUCKET, key: path, body: file)
    end
  end
end


