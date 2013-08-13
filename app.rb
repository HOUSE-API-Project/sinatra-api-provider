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
    if @params['from']
      begin
        from = Time.strptime(@params['from'], "%Y%m%d%H%M%S")
      rescue ArgumentError
        from = nil
      end
    else
      from = nil
    end

    if @params['to']
      begin
        to = Time.strptime(@params['to'], "%Y%m%d%H%M%S")
      rescue ArgumentError
        to = nil
      end
    else
      to = nil
    end

    if from and to
      @query_params[:time] = {"$gt" => from , "$lt" => to}
    end
  end

  def limit_parser
    if @params['limit'] == 0
      @limit_params[:limit] = nil
    elsif @params['limit']
      @limit_params[:limit] = @params['limit'].to_i
    end
  end

  def sort_parser
    if @params['sort'] == "asc"
      @sort_params[:time] = :asc
    end
  end

  def query
    @query_params = {}
    @limit_params = {:limit => 1}
    @sort_params = {:time => :desc}

    time_parser
    limit_parser
    sort_parser

    @coll.find(@query_params, @limit_params).sort(@sort_params)
  end

  # Logging
  configure :development, :production do
    enable :logging
  end

  # Reloader
  configure :development do
    register Sinatra::Reloader
  end

  # Root Index
  get '/' do
    haml :index
  end

  # Generic Routing
  get '/:tag_h/:tag_f' do
    content_type :json, :charset => 'utf-8'
    @coll = @db.collection(@params[:tag_h] + "." + @params[:tag_f])
    @params = Rack::Utils.parse_query(@env['rack.request.query_string'])
    json_array = query.to_a
    @json = (json_array.length == 1 ? json_array.last.to_json : json_array.to_json)
  end

  run! if app_file == $0
end
