class FacebookConnect

	def initialize
		@app_id = ENV['FACE_FRIENDS_APP_ID']
		#facebook app secret
		@app_s = ENV['FACE_FRIENDS_TOKEN']
		@face_url = "https://graph.facebook.com/oauth/access_token?grant_type=client_credentials&client_id=#{@app_id}&client_secret=#{@app_s}"
		@get_user_friends_url = "https://graph.facebook.com/v2.5/X/friends?"
	end


	def retrieve_facebook_access_token
		resp = does_external_facebook_get_request(@face_url)
		resp.try(:code) == '200' ? resp.body : nil
	end

	def retrieve_user_friends(id, access = nil)
		Rails.logger.debug "retrieve_user_friends -> #{id}, #{access}."
		access = retrieve_facebook_access_token unless access != nil
		#access_token = retrieve_facebook_access_token
		if !access.to_s.empty?
			friends_url = @get_user_friends_url << access.to_s.strip
			does_external_facebook_get_request(URI.encode(friends_url.gsub('X', id))).body
  	end
	end

	def does_external_facebook_get_request(url)
		Net::HTTP.get_response(URI.parse(url))
	end

end
