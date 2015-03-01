require 'rubygems'
require 'bundler/setup'

Bundler.require

root_dir = File.dirname(__FILE__)
app_file = File.join(root_dir, "app.rb")

require 'sinatra'
configure { set :server, :puma }

require app_file

run CineasteServer
