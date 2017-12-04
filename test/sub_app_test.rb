require File.expand_path('../test_assistant', __FILE__)
require "digest/md5"

module Pingpp
  class SubAppTest < Test::Unit::TestCase
    # 创建子商户 sub_app
    should "sub_app create" do
      user_id = Digest::MD5.hexdigest(Time.now.to_i.to_s)[0,12]
      display_name = 'sub_app_' + user_id

      params = {
        :display_name  => display_name,
        :user => user_id
      }

      sub_app = Pingpp::SubApp.create(params)

      assert sub_app.kind_of?(Pingpp::SubApp)
      assert sub_app.object == 'sub_app'
      assert sub_app.user == user_id
      assert sub_app.display_name == display_name
    end

    # 查询 sub_app
    should "sub_app retrieve" do
      sub_app = Pingpp::SubApp.retrieve(get_sub_app_id)

      assert sub_app.object == 'sub_app'
      assert sub_app.id == get_sub_app_id
    end

    # 查询 sub_app 列表
    should "sub_app list" do
      l = Pingpp::SubApp.list(:per_page => 3)

      assert l.object == 'list'
      assert l.data.count <= 3
      assert l.data[0].kind_of?(Pingpp::SubApp)
    end

    # 更新 sub_app
    should "sub_app update" do
      new_description = 'Shanghai ' + Time.now.iso8601
      sub_app = Pingpp::SubApp.update(get_sub_app_id, {:description => new_description})

      assert sub_app.kind_of?(Pingpp::SubApp)
      assert sub_app.object == 'sub_app'
      assert sub_app.id == get_sub_app_id
      assert sub_app.description == new_description
    end

    # 删除 sub_app
    should "sub_app delete" do
      sub_app = Pingpp::SubApp.delete(sub_app_id_to_delete)

      assert sub_app.deleted
      assert sub_app.id == sub_app_id_to_delete
    end
  end
end
