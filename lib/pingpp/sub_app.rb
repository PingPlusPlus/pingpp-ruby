module Pingpp
  class SubApp < AppBasedResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List
    include Pingpp::APIOperations::Delete
    include Pingpp::APIOperations::Update

    def self.object_name
      'sub_app'
    end
  end
end
