require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def test_save_from_omniauth
      info = ('')
      info.stubs(:name).returns('Tomas')

      credentials = ('')
      credentials.stubs(:expires_at).returns(1456926914)
      credentials.stubs(:token).returns('CAAUxBUcWfLABAFpsc2Dj6FdLLBgcDnTT1TKgceslkuNp4BSuO4aQLgIfguvNZBzH5pAJvasdsED9shukXifvQT4voqkCC4oUYwLKPV5xHk5H2DhLYgMZCVeN4W2oYvnj9S8MTOAMO5hmNbAWZBMtTCZBqQ5EYa1fX3uamoCoLp068ELHiz7rnpBkeConLrxeZB2wk2XaDRAZDZD')

      auth = ('')
      auth.stubs(:provider).returns('facebook')
      auth.stubs(:uid).returns('1532440350303095')
      auth.stubs(:info).returns(info)
      auth.stubs(:credentials).returns(credentials)
      user = User.from_omniauth(auth)
      assert_equal(auth.info.name, user.name)
  end

  def test_update_from_omniauth
    # setting intial configuration
    info = ('')
    info.stubs(:name).returns('Tomas')

    credentials = ('')
    credentials.stubs(:expires_at).returns(1456926914)
    credentials.stubs(:token).returns('CAAUxBUcWfLABAFpsc2Dj6FdLLBgcDnTT1TKgceslkuNp4BSuO4aQLgIfguvNZBzH5pAJvasdsED9shukXifvQT4voqkCC4oUYwLKPV5xHk5H2DhLYgMZCVeN4W2oYvnj9S8MTOAMO5hmNbAWZBMtTCZBqQ5EYa1fX3uamoCoLp068ELHiz7rnpBkeConLrxeZB2wk2XaDRAZDZD')

    auth = ('')
    auth.stubs(:provider).returns('facebook')
    auth.stubs(:uid).returns('1532440350303095')
    auth.stubs(:info).returns(info)
    auth.stubs(:credentials).returns(credentials)
    user = User.from_omniauth(auth)
    # check if the insert was ok
    assert_equal(auth.info.name, user.name)

    # retrieve the user's id before change it's value
    old_id = user.id
    # set the new user's name
    new_name = 'Tomas Alterado'
    info.stubs(:name).returns(new_name)
  #  auth.stubs(:uid).returns('112211221122')
    user = nil
    user = User.from_omniauth(auth)
    # check if the user's id is the same
    assert_equal(old_id, user.id)
    # check if the user's name was changed
    assert_equal(new_name, user.name)
  end

  def test_not_update_from_omniauth
    # setting intial configuration
    info = ('')
    info.stubs(:name).returns('Tomas')

    credentials = ('')
    credentials.stubs(:expires_at).returns(1456926914)
    credentials.stubs(:token).returns('CAAUxBUcWfLABAFpsc2Dj6FdLLBgcDnTT1TKgceslkuNp4BSuO4aQLgIfguvNZBzH5pAJvasdsED9shukXifvQT4voqkCC4oUYwLKPV5xHk5H2DhLYgMZCVeN4W2oYvnj9S8MTOAMO5hmNbAWZBMtTCZBqQ5EYa1fX3uamoCoLp068ELHiz7rnpBkeConLrxeZB2wk2XaDRAZDZD')

    auth = ('')
    auth.stubs(:provider).returns('facebook')
    auth.stubs(:uid).returns('1532440350303095')
    auth.stubs(:info).returns(info)
    auth.stubs(:credentials).returns(credentials)
    user = User.from_omniauth(auth)
    # check if the insert was ok
    assert_equal(auth.info.name, user.name)

    auth.stubs(:uid).returns('1122112211221122')

    # retrieve the user's id before change it's value
    old_id = user.id
    user = nil
    user = User.from_omniauth(auth)
    # check if the user's id is the same
    assert_not_equal(old_id, user.id)

  end

end
