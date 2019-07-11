module Pingpp
  class SplitProfit < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def self.object_name
      'split_profit'
    end

    def self.resource_url(opts={})
      '/v1/split_profits'
    end

  end
end
