require 'rack/test'
require 'webrat'
require File.join(File.dirname(__FILE__), '..', 'app.rb')

begin 
	require File.join(File.dirname(__FILE__), '..', 'app.rb')

rescue NameError
	require File.expand_path('../app.rb', __FILE__)
end

module RSpecMixin
	include Rack::Test::Methods
	def app() 
		Scuzzle 
	end
end

Webrat.configure do |config|
  config.mode = :rack
end

RSpec.configure  do |config|
	config.include Webrat
	config.include RSpecMixin
	config.include Haml::Helpers  
	config.before(:each) do
		init_haml_helpers
	end
end
