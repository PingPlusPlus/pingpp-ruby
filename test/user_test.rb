require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class UserTest < Test::Unit::TestCase
    should "execute should return a new user when passed correct parameters" do
      user_id = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
    
      params = {
        :id  => user_id
      }
    
      u = Pingpp::User.create(params)
    
      assert u.object == 'user'
      assert u.id == user_id
    end

    should "execute should return an exist user when passed correct id" do
      u = Pingpp::User.retrieve(get_user_id)

      assert u.object == 'user'
      assert u.id == get_user_id
    end

    should "execute should return a list of users when passed correct parameters" do
      u = Pingpp::User.list(:per_page => 3)

      assert u.object == 'list'
      assert u.data.count <= 3
    end

    should "execute should return an updated user" do
      new_address = 'Shanghai ' + Time.now.iso8601
      u = Pingpp::User.update(get_user_id, {:address => new_address})

      assert u.object == 'user'
      assert u.id == get_user_id
      assert u.address == new_address
    end
  end
end
