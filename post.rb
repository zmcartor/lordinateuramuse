require 'mongo_mapper'

class Post
  include MongoMapper::Document

  key :url, String
  key :date_posted, Date
  key :info_hash , String
  key :votes , Integer, :default =>0
  
  #keep timestamps automagicly
  timestamps!
end
