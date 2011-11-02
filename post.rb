require 'mongo_mapper'

class Post
	include MongoMapper::Document
	@@db_connection = MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com',10058, :pool_size => 5, :timeout => 5)
	@@database_name = MongoMapper.database = 'scrape'
	@@auth_creds = MongoMapper.database.authenticate('zm','Sup3rFun!')

	key :url, String
	key :date_posted, Date
	key :info_hash , String
	key :votes , Integer, :default =>0

	#keep timestamps automagicly
	timestamps!

	def self.recommended_today()
		self.all(:created_at => {'$gt' => 1.days.ago.midnight},:order=>'votes DESC')
	end

	def self.change_db(db_name)
		@@mongo_database = db_name
	end

	def self.add(url=nil)
		url = Digest::SHA1.hexdigest params[:url]
		unless url.nil?
			self.save(:url => url, :info_hash => hash)
		end
	end
end
