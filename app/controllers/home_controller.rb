class HomeController < ApplicationController

  def show
    puts "session #{session[:user_id]}"
    if session[:user_id] != nil
      Rails.logger.info "User logged #{session[:user_id]}"
      # retrieve user
      begin
        u = User.find(session[:user_id].to_i)
      rescue Exception => exc
        Rails.logger.error("Message for the log file #{exc.message}")
        Rails.logger.info("Removing user #{session[:user_id]} from session.")
        session.delete(:user_id)
      end
      #retrive user's friends
      @friends = MongoConnect.new.find_register_by_facebook_id(u.uid) unless u == nil
      if (@friends != nil && @friends.count > 0)
        #set into @friends the first register returned from MG DB
        @friends.each {|x|
           @friends = JSON.parse(x.to_json)
        }
        Rails.logger.info "Friends found #{@friends}"
      else
        @friends = nil
      end      
    end
    render "home/show"
  end
end
