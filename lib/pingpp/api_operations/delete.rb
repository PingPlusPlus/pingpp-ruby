module Pingpp
  module APIOperations
    module Delete
      def delete(params = {})
        response, api_key = Pingpp.request(:delete, url, @api_key, params)
        refresh_from(response, api_key)
      end
    end
  end
end
