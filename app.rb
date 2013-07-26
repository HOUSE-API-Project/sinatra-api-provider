# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'json'
require 'time'
require 'mongo'

class SinatraApiProvider < Sinatra::Base
  require './helpers/render_partial'

  get '/' do
    haml :index
  end

  get '/api.json' do
    content_type :json, :charset => 'utf-8'
    data = { "ほげ" => 1, "ふが" => 2 }
    topics = JSON.generate(data)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
