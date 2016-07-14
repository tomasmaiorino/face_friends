require 'test_helper'
require 'net/http'
require 'mocha/test_unit'
require 'net/http'

require "#{Rails.root}/lib/facebook_connect.rb"
class FaceBookConnectIntegrationTest < ActionController::TestCase

  def setup
    #returned ok
    @user_with_friends_id = '100428217015609'
    @access_token='1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk'
    @user_with_no_friends = '139656339755862'
    @invalid_user_id = '10042821701560'
#    @{"error"=>{"message"=>"An access token is required to request this resource.", "type"=>"OAuthException", "code"=>104, "fbtrace_id"=>"HC3BS5yylgV"}}
#'{"error": { "message": "An access token is required to request this resource.", "type": "OAuthException",  "code": 104, "fbtrace_id": "FZCYZmWgUNT" }}'
  end

  def test_retrieve_facebook_access_token
    fc = FacebookConnect.new
    access_token = fc.retrieve_facebook_access_token
    assert_not_nil(access_token)
  end

  def test_retrieve_user_friends_ok
    fc = FacebookConnect.new
    resp = fc.retrieve_user_friends(@user_with_friends_id)
    j = JSON.parse(resp)
    assert_not_equal(j['data'].length, 0)
  end

  def test_retrieve_user_friends_passing_access_code_ok
    fc = FacebookConnect.new
    # retrieve the facebook token
    access_token = fc.retrieve_facebook_access_token
    assert_not_nil(access_token)
    # call the retrieve_user_friends passing the access_token as parameter
    resp = fc.retrieve_user_friends(@user_with_friends_id, access_token)
    j = JSON.parse(resp)
    assert_not_equal(j['data'].length, 0)
  end

  def test_retrieve_user_friends_toke_not_informed
    fc = FacebookConnect.new
    # retrieve the facebook token
    access_token = fc.retrieve_facebook_access_token
    assert_not_nil(access_token)
    # call the retrieve_user_friends passing the access_token as parameter
    resp = fc.retrieve_user_friends(@user_with_friends_id, 'XXX')
    j = JSON.parse(resp)
    assert j['error'] != nil
    assert_equal(j['error']['code'], 104)
  end

  def test_retrieve_user_friends_passing_access_code_nok
    fc = FacebookConnect.new
    # retrieve the facebook token
    access_token = fc.retrieve_facebook_access_token
    assert_not_nil(access_token)
    j = JSON.parse(fc.retrieve_user_friends(@user_with_no_friends, access_token))
    assert_equal(j['data'].length, 0)
  end

  def test_retrieve_user_friends_nok
    fc = FacebookConnect.new
    j = JSON.parse(fc.retrieve_user_friends(@user_with_no_friends))
    assert_equal(j['data'].length, 0)
  end

  def test_retrieve_user_friends_error_body
    fc = FacebookConnect.new
    j = JSON.parse(fc.retrieve_user_friends(@invalid_user_id))
    assert_not_nil(j['error'])
  end

end
