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
    if @params['date']
      begin
        run_date = Date.strptime(@params['date'], "%Y%m%d")
      rescue ArgumentError
        run_date = Date.today
      end
    else
      run_date = Date.today
    end

    from = Time.parse((run_date).strftime("%Y%m%d"))
    to   = Time.parse((run_date + 1).strftime("%Y%m%d"))
    @json = @coll.find({:time => {"$gt" => from , "$lt" => to}})
    @json.to_a.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
