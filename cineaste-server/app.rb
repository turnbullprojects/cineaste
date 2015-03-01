require 'rubygems'
require 'json'
require 'sinatra/base'
require 'cineaste'

class CineasteServer < Sinatra::Base


  get '/dictionary/:dictionary/:phrase' do
    content_type :json
    @dictionary = params[:dictionary]
    @phrase = params[:phrase]
    @voice = params[:voice] || "male"
    
    encoder = Cineaste::Phrase.new(@dictionary,@phrase,@voice)
    video = encoder.get_video
    return { video: video }.to_json

  end

  run! if app_file == $0
end
   
