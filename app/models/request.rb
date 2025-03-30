# frozen_string_literal: true

module Request
  def self.perform(url:, type: :get, body: {}, get_vars: {}, headers: {})
    Thing.new(type:, url:, body:, headers:, get_vars:).perform
  end

  Thing =
    Struct.new(:type, :url, :headers, :get_vars, :body) do
      def perform
        puts "Requesting #{http_request.uri}"
        response = http.request(http_request)
        return JSON.parse(response.body.force_encoding('UTF-8'), symbolize_names: true) if response.code == '200'
        {}
      end

      private

      def http_request
        return @http_request if @http_request
        uris = URI.encode_www_form(**get_vars) if get_vars.any?
        pp url
        @http_request = net_type.new(URI("#{url}#{uris ? "?#{uris}" : ''}"), **headers)
        @http_request['Content-Type'] = 'application/json'
        @http_request['Accept'] = 'application/json'
        @http_request.body = body.to_json if body != {}
        @http_request
      end

      def http
        https = Net::HTTP.new(http_request.uri.host, http_request.uri.port)
        https.use_ssl = http_request.uri.host.include?('https')
        https
      end

      def net_type
        case type
        when :get
          Net::HTTP::Get
        when :post
          Net::HTTP::Post
        end
      end
    end
end
