# frozen_string_literal: true

module Request
  def self.perform(url:, type: :get, body: {}, get_vars: {}, headers: {})
    Thing.new(type:, url:, body:, headers:, get_vars:).perform
  end

  OKAY_RESPONSES = %w[200 204].freeze

  Thing =
    Struct.new(:type, :url, :headers, :get_vars, :body) do
      def perform(retry_count: 0)
        request = http_request
        log_request(request:)
        response = http.request(request)
        if OKAY_RESPONSES.include?(response.code)
          return JSON.parse(response.body.force_encoding('UTF-8'), symbolize_names: true) if response.body.present?
        elsif response.code == '429'
          handle_rate_limit(retry_count:, response:)
        elsif response.code != '404'
          raise "Error: #{response.code} - #{response.message} - #{response.body}"
        end
        {}
      end

      delegate :debug?, to: :config

      private

      def config
        @config ||= Config.get
      end

      def log_request(request:)
        return unless debug?
        puts "Requesting #{request.uri}"
        pp body if request.body
      end

      def handle_rate_limit(retry_count:, response:)
        if retry_count >= 5
          raise "Rate limit exceeded after #{retry_count} retries. " \
                  "Last response: #{response.code} - #{response.message}"
        end
        retry_count += 1
        response_payload = JSON.parse(response.body.force_encoding('UTF-8'), symbolize_names: true)
        sleep_time = response_payload[:retry_after] + 0.1
        puts "Rate limit exceeded, sleeping for #{sleep_time} seconds"
        sleep(sleep_time)
        perform(retry_count:)
      end

      def http_request
        return @http_request if @http_request
        uris = URI.encode_www_form(**get_vars) if get_vars.any?
        @http_request = net_type.new(URI("#{url}#{"?#{uris}" if uris}"), **headers)
        @http_request['Content-Type'] = 'application/json'
        @http_request['Accept'] = 'application/json'
        @http_request.body = body.to_json if body != {}
        @http_request
      end

      def http
        https = Net::HTTP.new(http_request.uri.host, http_request.uri.port)
        https.use_ssl = http_request.uri.scheme == 'https'
        https
      end

      def net_type
        return Net::HTTP::Post if type == :post
        Net::HTTP::Get
      end
    end
end
