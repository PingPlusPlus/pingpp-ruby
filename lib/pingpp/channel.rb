module Pingpp
  class Channel < SubAppBasedResource
    extend Pingpp::APIOperations::Create
    include Pingpp::APIOperations::Delete
    include Pingpp::APIOperations::Update

  end
end
