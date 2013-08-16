require File.dirname(__FILE__) + '/spec_helper'

require 'fluent-logger'
require 'net/http'
require 'uri'
require 'json'

describe "App" do
  include Rack::Test::Methods

  def app
    @app ||= SinatraApiProvider
  end

  def setup
    @fluentd = Fluent::Logger::FluentLogger.open(nil,
      host = '133.242.144.202',
      port = 19999)
    @fluentd.post('rspec.debug.forward', {"hoge" => "fuga"})
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should return the correct content-type when viewing root" do
    get '/'
    last_response.headers["Content-Type"].should == "text/html;charset=utf-8"
  end

  it "should return 404 when page cannot be found" do
    get '/404'
    last_response.status.should == 404
  end

  it "should respond to /" do
    get '/'
    last_response.should be_ok
  end

  it "should respond to /rspec/debug/forward" do
    get '/rspec/debug/forward'
    last_response.should be_ok
  end

  it "should respond to /" do
    result = JSON.parse(Net::HTTP.get(URI.parse('http://133.242.144.202/api/rspec/debug/forward?limit=1')))
    result["hoge"].should == "fuga"
  end
end
