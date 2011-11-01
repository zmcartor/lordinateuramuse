require 'rack/test'
require 'webrat'

begin 
	require_relative '../app.rb'
rescue NameError
	require File.expand_path('../app.rb', __FILE__)
end

module RSpecMixin
	include Rack::Test::Methods
	include Webrat::HaveTagMatcher
	def app() Sinatra::Application end
end

Webrat.configure do |config|
  config.mode = :rack
end

RSpec.configure  do |config|
	config.include Webrat::HaveTagMatcher
	config.include Webrat
	config.include RSpecMixin
	config.include Haml::Helpers  
	config.before(:each) do
		init_haml_helpers
	end
end
