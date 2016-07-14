require "resolv-replace.rb"

class MongoConnect

 #attr_reader :mongo_client

	def initialize
		mongo_url = Rails.configuration.mongo_url
		mongo_port = Rails.configuration.mongo_port
		mongo_database = Rails.configuration.mongo_database
		@mongo_client = Mongo::Client.new([ "#{mongo_url}:#{mongo_port}" ], :database => mongo_database)
	end

 def insert_friends(data)
	 Rails.logger.debug "insert_friends -> #{data}."
	 if @mongo_client[:friends].find({:fc_id => data['fc_id']}).count == 1
		 Rails.logger.debug "Updating FC_ID: #{data['fc_id']}"
		 update_register_by_facebook_id(data['fc_id'], data)
	 else
		 @mongo_client[:friends].insert_one(data)
	end
 end

 def delete_register_by_facebook_id(fc_id)
	 Rails.logger.debug "Removing friends from facebook id #{fc_id}."
	 result =  @mongo_client[:friends].delete_many("fc_id" => fc_id)
	 return result.n
 end

 def update_register_by_facebook_id(fc_id, data)
	 Rails.logger.debug "update_register_by_facebook_id -> #{fc_id}, #{data}."
	 @mongo_client[:friends].find(:fc_id => fc_id).replace_one(data).n
 end

 def find_register_by_facebook_id(fc_id)
	 Rails.logger.debug "find_register_by_facebook_id -> #{fc_id}."
	 @mongo_client[:friends].find({:fc_id => fc_id})
 end
end
