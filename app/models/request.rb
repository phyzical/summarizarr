# frozen_string_literal: true

module Request
  def self.perform(url:, api_key:, get_vars: {}, headers: {})
    Thing.new(url:, api_key:, headers:, get_vars:).perform
  end

  Thing =
    Struct.new(:url, :api_key, :headers, :get_vars) do
      def perform
        items = []
        page = 1
        loop do
          page += 1
          response = http.request(http_request(page:))
          json = JSON.parse(response.body, symbolize_names: true)
          page += 1
          items << json[:items]
          break if json[:items] < get_vars[:pageSize]
        end
      end

      def http_request(page:)
        uris = URI.encode_www_form(**get_vars, page:)
        url = URI("#{perform}?#{uris}")
        request = type.new(url)
        request.merge(headers)
        request['Content-Type'] = 'application/json'
        request['Accept'] = 'application/json'
        request['Authorization'] = "Bearer #{api_key}"
        request.body = JSON.generate(body)
        request
      end

      def http
        https = Net::HTTP.new(http_request.uri.host, http_request.uri.port)
        https.use_ssl = http_request.uri.host.include?('https')
        https
      end
    end
end
