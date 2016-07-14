require 'test_helper'
require 'net/http'
require 'mocha/test_unit'
require 'net/http'

require "#{Rails.root}/lib/facebook_connect.rb"
class FaceBookConnectTest < ActionController::TestCase


  def setup
    #returned ok
    @user_friends_returned_ok = '{"data":[{"name":"Jean Grey","id":"1749693855259763"},{"name":"Professor Charles","id":"113125469077122"}],"paging":{"next":"https:\/\/graph.facebook.com\/v2.5\/100428217015609\/friends?access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk&limit=25&offset=25&__after_id=enc_AdDgSxNMBIQ3m58AKvmankKJrpNkZCJ1EyvO7zUGMyeBQoSXzALD7pXmXJIWToWSaZAwbr5uG9yxc6CgSWZBSzCdlTU"},"summary":{"total_count":2}}'
    @user_friends_not_returned = '{"data": [], "summary": {"total_count": 0 }}'
    @invalid_token_return = '{"error": {"message": "Invalid OAuth access token signature.","type": "OAuthException","code": 190,"fbtrace_id": "CxhL+57wd2K" }}'
    @user_id = '100428217015609'
    @access_token='1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk'
    @access_token_return='access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk'
  end

  def test_retrieve_facebook_access_token_http_400
    data = ''
    fc = FacebookConnect.new
    fc.stubs(:does_external_facebook_get_request).returns(data)
    #sets 400 the get_resquest http response// code
    data.stubs(:code).returns('400')
    access_token = fc.retrieve_facebook_access_token
    assert_nil(access_token)
  end

  def test_retrieve_facebook_access_token_nok
    # sets get_resquest return = nil
    fc = FacebookConnect.new
    fc.stubs(:does_external_facebook_get_request).returns(nil)
    access_token = fc.retrieve_facebook_access_token
    assert_nil(access_token)
  end


  def test_retrieve_facebook_access_token
    data = ''
    fc = FacebookConnect.new
    fc.stubs(:does_external_facebook_get_request).returns(data)
    #sets 400 the get_resquest http response code
    data.stubs(:code).returns('200')
    data.stubs(:body).returns(@access_token_return)
    access_token = fc.retrieve_facebook_access_token
    assert(access_token.to_s.include? 'access_token' )
  end

  def test_retrieve_user_friends_ok
    #mock the retrive access token function call
    temp_access_token = @access_token
    temp_access_token.stubs(:nil).returns(false)
    fc = FacebookConnect.new
    fc.stubs(:retrieve_facebook_access_token).returns(@access_token)

    #mock the does external call function that retrieve users friends
    data = @user_friends_returned_ok
    data.stubs(:code).returns('200')
    data.stubs(:body).returns(data)
    fc.stubs(:does_external_facebook_get_request).returns(data)

    resp = fc.retrieve_user_friends(@user_id)
    j = JSON.parse(resp)
    assert_not_equal(j['data'].length, 0)
  end

  def test_retrieve_user_friends_nok
    fc = FacebookConnect.new
    fc.stubs(:retrieve_user_friends).returns(@user_friends_not_returned)
    j = JSON.parse(fc.retrieve_user_friends(@user_id))
    assert_equal(j['data'].length, 0)
  end
end
