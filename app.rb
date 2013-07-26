# -*- coding: utf-8 -*-
require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'json'
require 'time'
require 'mongo'

class SinatraApiProvider < Sinatra::Base
  require './helpers/render_partial'

  def initialize(app = nil, params = {})
    super(app)
    @run_date      = Date.today
    @mongo         = Mongo::Connection.new('localhost', 27017)
    @db            = @mongo.db('fluentd')
    @coll          = @db.collection('news.feed')
  end

  #get '/' do
  #  haml :index
  #end

  get '/news.today' do
    content_type :json, :charset => 'utf-8'

    from = Time.parse((@run_date).strftime("%Y%m%d"))
    @json = @coll.find({:time => {"$gt" => from}})
    @json.to_a.to_json
  end

  get '/news.yesterday' do
    content_type :json, :charset => 'utf-8'

    from = Time.parse((@run_date - 1).strftime("%Y%m%d"))
    to   = Time.parse((@run_date).strftime("%Y%m%d"))
    @json = @coll.find({:time => {"$gt" => from , "$lt" => to}})
    @json.to_a.to_json
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
