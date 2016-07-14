require 'test_helper'
require 'mocha/test_unit'
require 'net/http'


class SessionsControllerTest < ActionController::TestCase

  # called before every single test

  test "should get create" do
    info = ('')
    info.stubs(:name).returns('Tomas')

    credentials = ('')
    credentials.stubs(:expires_at).returns(1456926914)
    credentials.stubs(:token).returns('CAAUxBUcWfLABAFpsc2Dj6FdLLBgcDnTT1TKgceslkuNp4BSuO4aQLgIfguvNZBzH5pAJvasdsED9shukXifvQT4voqkCC4oUYwLKPV5xHk5H2DhLYgMZCVeN4W2oYvnj9S8MTOAMO5hmNbAWZBMtTCZBqQ5EYa1fX3uamoCoLp068ELHiz7rnpBkeConLrxeZB2wk2XaDRAZDZD')

    auth = ('')
    auth.stubs(:provider).returns('facebook')
    auth.stubs(:uid).returns('100428217015609')
    auth.stubs(:info).returns(info)
    auth.stubs(:credentials).returns(credentials)

    #controller.stub(:retrieve_users_friends).returns({123,123,123})

    @request.env["omniauth.auth"] = auth
    get :create
    #check wheter the user was save correctly
    assert_equal(User.find_by(:uid => '100428217015609').uid, '100428217015609')
    assert_response :redirect
    assert_redirected_to root_path
    assert_not_nil assigns(:friends)
  end

  test "should reaised NoMethodError" do
    assert_raises(NoMethodError){
      info = ('')
      info.stubs(:name).returns('Tomas')

      auth = ('')
      auth.stubs(:provider).returns('facebook')
      auth.stubs(:uid).returns('1532440350303095')
      auth.stubs(:info).returns(info)
      #doesn't set the credentials in order to throw an error
      auth.stubs(:credentials).returns()

      @request.env["omniauth.auth"] = auth
      get :create
      assert_response :error
    }
  end
end
