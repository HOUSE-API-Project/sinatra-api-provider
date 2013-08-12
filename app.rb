# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'sinatra/reloader'
require 'haml'
require 'json'
require 'date'
require 'time'
require 'mongo'

class SinatraApiProvider < Sinatra::Base
  require './helpers/render_partial'

  def initialize(app = nil, params = {})
    super(app)
    @mongo    = Mongo::Connection.new('localhost', 27017)
    @db       = @mongo.db('houseapi')
  end

  def time_parser
    params   = Rack::Utils.parse_query(@env['rack.request.query_string'])

    if params['from']
      begin
        from = Time.strptime(params['from'], "%Y%m%d%H%M%S")
      rescue ArgumentError
        from = Time.parse((Date.today - 1).strftime("%Y%m%d"))
      end
    else
      from = Time.parse((Date.today - 1).strftime("%Y%m%d"))
    end

    if params['to']
      begin
        to = Time.strptime(params['to'], "%Y%m%d%H%M%S")
      rescue ArgumentError
        to = Time.parse((Date.today + 1).strftime("%Y%m%d"))
      end
    else
      to = Time.parse((Date.today + 1).strftime("%Y%m%d"))
    end

    return from, to
  end

  configure :development, :production do
    enable :logging
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/' do
    haml :index
  end

  get '/:tag_h/:tag_f' do
    content_type :json, :charset => 'utf-8'
    from, to = time_parser
    @coll = @db.collection(params[:tag_h] + "." + params[:tag_f])
    json_array = @coll.find({:time => {"$gt" => from , "$lt" => to}}).to_a
    @json = (json_array.length == 1 ? json_array.last.to_json : json_array.to_json)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
