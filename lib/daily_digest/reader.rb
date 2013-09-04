require 'uri'

module DailyDigest
  class Reader
    include Client

    attr_reader :token

    def initialize(token)
      @token = token
    end

    def endpoint(url)
      query = URI.encode_www_form("url" => url, "token" => token)
      URI.parse("https://readability.com/api/content/v1/parser?#{query}")
    end

    def get(url)
      Article.new(request(endpoint(url)))
    end

    class Article
      def initialize(data)
        @data = data
      end

      def title
        @data['title']
      end

      def domain
        @data['domain']
      end

      def url
        @data['url']
      end

      def author
        @data['author']
      end

      def content
        @data['content']
      end

      def date
        Time.parse(@data['date_published'])
      end
    end
  end
end
