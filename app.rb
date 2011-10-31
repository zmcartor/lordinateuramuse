require 'sinatra'
require 'haml'
require 'URI'
require 'mechanize'
require 'logger'
require 'mongo_mapper'
require 'digest/sha1'


#custom class for mongo document
require './post'
MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com',10058, :pool_size => 5, :timeout => 5)
MongoMapper.database = 'scrape'
MongoMapper.database.authenticate('zm','Sup3rFun!')

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

set :port , 8080

# root page
get '/' do 
	#show a list of days with content.
	#show a page of all-time greats
	haml :index
end


get '/scraped' do
	#because passing in URI, must decode
	@url= URI::decode params[:url]

	unless @url.start_with? 'http://'
		@url.insert(0,'http://')
	end

	#grab with mechanize
	#likely need some better error checking around here.

	Log.info("Going to "+@url)
	agent = Mechanize.new

	#catch any errors that may occur, could be more specific
	#in handling

	begin
		agent.get @url do |page|

			@title = page.title
			@links = page.links
			@images = page.image_urls

		end
	rescue
		Log.info("Not a valid URL, could not read source or something else bad happened: "+@url)
		halt haml(:broken)
	end

	#TODO other feature ideas
	#for the whole scraped HTML: use page.body
	#Ensure scraper isn't used as XSS/SQl injection bot
	haml :scraped
end

post "/recommend" do
	today = Date.today.strftime "%m-%d-%Y"
	hash = Digest::SHA1.hexdigest params[:url]
	puts params[:url]

	#TODO no duplicate posts
	new_post = Post.new(:url=>params[:url] , :date_posted=>today, :info_hash=>hash)
	new_post.save
end

get "/recommended"  do
	#just recommened images for now. Could share other types of data in future
	date = params[:date] || Date.today.strftime("%m-%d-%Y")
	Post.all(:created_at => {'$gt' => 1.days.ago.midnight, :order=>'votes'})
	@posts = Post.all
	haml :recommended
end

post "/upvote" do
	Post.increment({:url=>params[:url]}, :votes => 1)
end

post "/downvote" do
	Post.decrement({:url=>params[:url]}, :votes => 1)
end
