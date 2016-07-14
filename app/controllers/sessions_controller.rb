require "#{Rails.root}/lib/facebook_connect.rb"
require 'mongo_connect'

class SessionsController < ApplicationController

  def initialize(fb = FacebookConnect.new, mg = MongoConnect.new)
    @fb = fb
    @mg = mg
  end

  def create
   Rails.logger.debug "Facebook data #{request.env['omniauth.auth']}"
   user = User.from_omniauth(request.env["omniauth.auth"])
   puts "user #{user}"
   #set user id into session
   session[:user_id] = user.id
   #retrieves the friends from  user
   @friends = create_user_face_register(user)
   #set into @friends the first register returned from MG DB
   @friends.each {|x|
      @friends = x.to_json
   }
   puts "friends #{@friends}"
   redirect_to root_path @friends
  end

 def destroy
   session[:user_id] = nil
   redirect_to root_path
 end

 def retrieve_users_friends(uid)
   @mg.find_register_by_facebook_id(uid)
 end

 #private:
 def create_user_face_register(user)
   user_data = nil
   user_data = @fb.retrieve_user_friends(user.uid)
   user_data = JSON.parse(user_data)
   user_data["fc_id"] = user.uid
   @mg.insert_friends(user_data)
   @mg.find_register_by_facebook_id(user.uid)
 end
end
