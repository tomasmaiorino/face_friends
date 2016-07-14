require 'test_helper'

class MongoConnectTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  #
  # SETUP METHODS
  #
  def setup
    @mongo_connect =  MongoConnect.new
    @user_friends_data_ok = '{"fc_id": "100428217015609", "data":[{"name":"Jean Grey","id":"1749693855259763"},{"name":"Professor Charles","id":"113125469077122"}],"paging":{"next":"https:\/\/graph.facebook.com\/v2.5\/100428217015609\/friends?access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk&limit=25&offset=25&__after_id=enc_AdDgSxNMBIQ3m58AKvmankKJrpNkZCJ1EyvO7zUGMyeBQoSXzALD7pXmXJIWToWSaZAwbr5uG9yxc6CgSWZBSzCdlTU"},"summary":{"total_count":2}}'
    @user_id = '100428217015609'
    @user_friends_data_ok_2 = '{"fc_id": "100428217015111", "data":[{"name":"Jean Grey","id":"1749693855259763"},{"name":"Professor Charles","id":"113125469077122"}],"paging":{"next":"https:\/\/graph.facebook.com\/v2.5\/100428217015609\/friends?access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk&limit=25&offset=25&__after_id=enc_AdDgSxNMBIQ3m58AKvmankKJrpNkZCJ1EyvO7zUGMyeBQoSXzALD7pXmXJIWToWSaZAwbr5uG9yxc6CgSWZBSzCdlTU"},"summary":{"total_count":2}}'
    @user_id_2 = '100428217015111'
    @user_friends_data_ok_3 = '{"fc_id": "100428217015444", "data":[{"name":"Jean Grey","id":"1749693855259763"},{"name":"Professor Charles","id":"113125469077122"}],"paging":{"next":"https:\/\/graph.facebook.com\/v2.5\/100428217015609\/friends?access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk&limit=25&offset=25&__after_id=enc_AdDgSxNMBIQ3m58AKvmankKJrpNkZCJ1EyvO7zUGMyeBQoSXzALD7pXmXJIWToWSaZAwbr5uG9yxc6CgSWZBSzCdlTU"},"summary":{"total_count":2}}'
    @user_id_3 = '100428217015444'
    @mongo_connect.insert_friends(JSON.parse(@user_friends_data_ok))
  end

  def teardown
    @mongo_connect.delete_register_by_facebook_id(@user_id)
  end

  def test_insert_friend
    # adding user's friend
    @mongo_connect.insert_friends(JSON.parse(@user_friends_data_ok_2))
    assert_equal(@mongo_connect.find_register_by_facebook_id(@user_id_2).count, 1)
    # removing user register in order to clean database
    @mongo_connect.delete_register_by_facebook_id(@user_id_2)
  end

  def test_insert_and_update_friend
    # adding user's friend
    @mongo_connect.insert_friends(JSON.parse(@user_friends_data_ok_3))
    assert_equal(@mongo_connect.find_register_by_facebook_id(@user_id_3).count, 1)
    #creates the new content
    new_content = '{"fc_id": "100428217015444", "data":[{"name":"Jean Grey New","id":"1749693855259763"}],"paging":{"next":"https:\/\/graph.facebook.com\/v2.5\/100428217015609\/friends?access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk&limit=25&offset=25&__after_id=enc_AdDgSxNMBIQ3m58AKvmankKJrpNkZCJ1EyvO7zUGMyeBQoSXzALD7pXmXJIWToWSaZAwbr5uG9yxc6CgSWZBSzCdlTU"},"summary":{"total_count":2}}'
    new_friends_qtd = nil
    #does another user insert
    @mongo_connect.insert_friends(JSON.parse(new_content))
    # search for the new record
    @mongo_connect.find_register_by_facebook_id(@user_id_3).each { |v|
      new_friends_qtd = v['data'].length
    }
    assert_equal(new_friends_qtd, 1)
    new_name = nil
    @mongo_connect.find_register_by_facebook_id(@user_id_3).each { |v|
      new_name = v['data'][0][:name]
    }
    assert_equal(new_name, 'Jean Grey New')
    # removing user register in order to clean database
    @mongo_connect.delete_register_by_facebook_id(@user_id_3)
  end

  def test_removing_friend
    # adding user register in order to  rest delete
    @mongo_connect.insert_friends(JSON.parse(@user_friends_data_ok_2))
    assert_equal(@mongo_connect.delete_register_by_facebook_id(@user_id_2), 1)
  end

  def test_update_users_friends_by_id
    # parse the user data
    me = JSON.parse(@user_friends_data_ok)
    # set the new friends register with only one friend
    new_content = '{"fc_id": "100428217015609", "data":[{"name":"New Grey","id":"1749693855259763"}],"paging":{"next":"https:\/\/graph.facebook.com\/v2.5\/100428217015609\/friends?access_token=1461273620806832|SS2CzPMqETkEqtb5uenOoYzMtOk&limit=25&offset=25&__after_id=enc_AdDgSxNMBIQ3m58AKvmankKJrpNkZCJ1EyvO7zUGMyeBQoSXzALD7pXmXJIWToWSaZAwbr5uG9yxc6CgSWZBSzCdlTU"},"summary":{"total_count":1}}'
    new_friends_qtd = nil
    #update friend register
    @mongo_connect.update_register_by_facebook_id(@user_id, JSON.parse(new_content))
    # search for the new record
    @mongo_connect.find_register_by_facebook_id(@user_id).each { |v|
 	 	  new_friends_qtd = v['data'].length
 	  }
    assert_equal(new_friends_qtd, 1)
  end
=begin
=end
end
