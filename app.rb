# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'haml'
require 'json'
require 'time'
require 'mongo'

class SinatraApiProvider < Sinatra::Base
  require './helpers/render_partial'

  def initialize(app = nil, params = {})
    super(app)
    @mongo    = Mongo::Connection.new('localhost', 27017)
    @db       = @mongo.db('fluentd')
    @coll     = @db.collection('news.feed')
  end

  configure :development, :production do
    enable :logging
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/news' do
    content_type :json, :charset => 'utf-8'
    @params   = Rack::Utils.parse_query(@env['rack.request.query_string'])
    if @params['from']
      begin
        from = Time.strptime(@params['from'], "%Y%m%d%H%M%S")
      rescue ArgumentError
        from = Time.today
      end
    else
      from = Time.today
    end
    if @params['to']
      begin
        to = Time.strptime(@params['to'], "%Y%m%d%H%M%S")
      rescue ArgumentError
        to = Time.today
      end
    else
      to = Time.today
    end

    @json = @coll.find({:time => {"$gt" => from , "$lt" => to}})
    @json.to_a.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
