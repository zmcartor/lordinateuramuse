require File.join(File.dirname(__FILE__), '..', 'app.rb')
require 'rack/test'
require 'rspec'
require 'rspec/autorun'
require 'test/unit'
require 'spec_helper'

set :environment, :test

describe 'Scuzzle Scrape index' do
	before(:each) do
		set :views => File.join(File.dirname(__FILE__), "..", "views")
	end

	def app
		@app ||= Sinatra::Application
	end

	it "should show a search box on /" do
		get '/'
		last_response.body.should include "<form action='/scraped' id='email' method='get' name='scrape'>"
	end

	it "should throw an error with a non URL" do
		get '/scraped?url=fffff'
		last_response.body.should include "Arghh ya broke it!"
	end
end


describe "Scuzzle picture recommend" do

	it "show pictures from Reddpics" do

	end

	it "recommend an img" do

	end

end
