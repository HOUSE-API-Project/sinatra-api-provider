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

    @run_date      = Date.today
    @pickup_date   = (@run_date - 1).strftime("%Y%m%d")
    @today         = @run_date.strftime("%Y%m%d")

    @mongo         = Mongo::Connection.new('localhost', 27017)
    @db            = @mongo.db('fluentd')
    @coll          = @db.collection('raspberry.temperature')

    from = Time.parse(@pickup_date)
    to   = Time.parse(@today)
    @json = @coll.find({:time => {"$gt" => from , "$lt" => to}})
    @json.to_a.to_json
 end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
