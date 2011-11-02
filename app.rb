require 'sinatra/base'
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

class Scuzzle < Sinatra::Base

	configure do
		set :views, "#{File.dirname(__FILE__)}/views"

		enable :logging

		#setup some app variables here for fun..
		APP_SETTINGS = OpenStruct.new(
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

	get '/' do 
		haml :index
	end


	get '/scraped' do
		#because passing in URI, must decode
		@url= URI::decode params[:url]

		unless @url.start_with? 'http://'
			@url.insert(0,'http://')
		end

		Log.info("Going to "+@url)
		agent = Mechanize.new

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

		haml :scraped
	end

	post "/recommend" do
		hash = Digest::SHA1.hexdigest params[:url]
		Post.add(params[:url])
	end

	get "/recommended"  do
		date = params[:date] || Date.today.strftime("%m-%d-%Y")
		@posts = Post.recommended_today
		haml :recommended
	end

	post "/upvote" do
		Post.increment({:url=>params[:url]}, :votes => 1)
		puts 'OK'
	end

	post "/downvote" do
		Post.decrement({:url=>params[:url]}, :votes => 1)
		puts 'OK'
	end
end
