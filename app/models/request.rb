# frozen_string_literal: true

module Request
  def self.perform(url:, get_vars: {}, headers: {})
    Thing.new(url:, headers:, get_vars:).perform
  end

  Thing =
    Struct.new(:url, :headers, :get_vars, :body) do
      def perform
        puts "Requesting #{http_request.uri}"
        response = http.request(http_request)
        return JSON.parse(response.body.force_encoding('UTF-8'), symbolize_names: true) if response.code == '200'
        {}
      end

      def http_request
        return @http_request if @http_request
        uris = URI.encode_www_form(**get_vars) if get_vars.any?
        @http_request = Net::HTTP::Get.new(URI("#{url}?#{uris}"), **headers)
        @http_request['Content-Type'] = 'application/json'
        @http_request['Accept'] = 'application/json'
        @http_request
      end

      def http
        https = Net::HTTP.new(http_request.uri.host, http_request.uri.port)
        https.use_ssl = http_request.uri.host.include?('https')
        https
      end
    end
end
