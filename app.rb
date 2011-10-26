require 'sinatra'
require 'haml'
require 'URI'
require 'mechanize'
require 'logger'

configure do
  set :views, "#{File.dirname(__FILE__)}/views"

  enable :logging

  #setup some app variables here for fun..
  App_settings = OpenStruct.new(
	  :title=>'ScuzzleScrape',
	  :author=>'@zmcartor'
  )

  Log = Logger.new("sinatra.log")
  Log.level  = Logger::INFO
end


error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end


# root page
get '/' do
  haml :index
end

get '/scraped' do
	#because passing in URI, must decode
	@url= URI::decode params[:url]
	
	unless @url.start_with? 'http://'
		@url.insert(0,'http://')
	end

	#grab with mechanize
	#likely need some error checking around here.

	Log.info("Going to "+@url)
	agent = Mechanize.new

	@images, @links = Array.new
	@body = ''

	#catch any errors that may occur, could be more specific
	#in handling

	begin
		agent.get @url do |page|
			@body = page.body
			@links = page.image_urls
			@images = page.image_urls
		end
	rescue
		Log.info("Not a valid URL, could not read source: "+@url)

	end
	#grab the url in question

	#check if starts with valid protocol

	# run through and print out resources included on page

	#puts page.body, w00t!!
end
#grab all images
#grab all scripts
#check for security bot thing
#search around for a 

haml :scraped

end
