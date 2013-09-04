require 'uri'

module DailyDigest
  class Pocket
    include Client

    attr_reader :access_token, :consumer_key

    def initialize(token, key)
      @access_token = token
      @consumer_key = key
    end

    def endpoint
      URI.parse("https://getpocket.com/v3/get?access_token=#{access_token}&consumer_key=#{consumer_key}")
    end

    def list
      data = request(endpoint)['list']
      data.values.map { |item| Item.new(item) }.sort_by(&:item_id).reverse
    end

    class Item
      def initialize(data)
        @data = data
      end

      def item_id
        @data['item_id'].to_i
      end

      def title
        @data['resolved_title']
      end

      def url
        @data['resolved_url']
      end
    end
  end
end

