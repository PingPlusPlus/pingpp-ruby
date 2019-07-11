module Pingpp
  class SubBank < APIResource
    extend Pingpp::APIOperations::List

    def self.object_name
      'sub_bank'
    end

    def self.resource_url(opts={})
      '/v1/sub_banks'
    end

    def self.query(params={}, opts={})
      list(params, opts)
    end

  end
end
