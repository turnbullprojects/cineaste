require 'aws-sdk'

module Cineaste::Helpers
  S3_BUCKET = 'crumbles-2015'

  def s3_bucket
    'crumbles-2015'
  end


  def s3_url(obj)
    obj.presigned_url(:get, expires_in: 3600)
  end

  def get_media(path) 
    begin
      return @s3.get_object(bucket: S3_BUCKET, key: path) 
    rescue Aws::S3::Errors::NoSuchKey 
      return nil
    end
  end


end
