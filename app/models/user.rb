#require_dependency 'validators/email_validator.rb'
class User < ActiveRecord::Base
  validates :provider, presence: true, length: {maximum: 50}
  validates :uid, presence: true, length: {maximum: 50}
  validates :name, presence: true, length: {maximum: 50}
  validates :oauth_expires_at, presence: true, length: {maximum: 50}
  validates :oauth_token, presence: true

  def self.from_omniauth(auth)
    User.where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
    #   user = Userface.new
       user.provider = auth.provider
       user.uid = auth.uid
       user.name = auth.info.name
       user.oauth_token = auth.credentials.token
       user.oauth_expires_at = Time.at(auth.credentials.expires_at)
       user.save!
       return user
     end
   end
end
