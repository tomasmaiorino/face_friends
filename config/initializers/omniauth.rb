OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACE_FRIENDS_APP_ID'], ENV['FACE_FRIENDS_TOKEN'], :scope => 'email,user_friends', :display => 'popup',
  :client_options => {
      :ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}
  }
end
