module Pingpp
  class Refund < APIResource
    extend Pingpp::APIOperations::Create
    extend Pingpp::APIOperations::List

    def self.retrieve(charge, id, opts={})
      opts[:parents] = ['charges', charge]
      super(id, opts)
    end

    def self.create(charge, params, opts={})
      opts[:parents] = ['charges', charge]
      super(params, opts)
    end

    def self.list(charge, filters={}, opts={})
      opts[:parents] = ['charges', charge]
      super(filters, opts)
    end

    singleton_class.send(:alias_method, :all, :list)
  end
end
