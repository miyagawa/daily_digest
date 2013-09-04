require 'json'
require 'net/http'

module DailyDigest
  module Client
    def request(uri)
      response = Net::HTTP.get_response(uri)
      JSON.parse(response.body)
    end
  end
end
