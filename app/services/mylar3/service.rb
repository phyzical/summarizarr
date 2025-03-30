# frozen_string_literal: true

module Mylar3
  class Service < BaseService
    # curl -X 'GET' 'http://mylar3:8090/api?cmd=getHistory&apikey=asd'   -H 'accept: application/json'
    # curl -X 'GET' 'http://mylar3:8090/api?cmd=getVersion&apikey=asd'   -H 'accept: application/json'

    private

    class << self
      def api_prefix
        '/api'
      end

      def status_cmd
        'getVersion'
      end

      def history_cmd
        'getHistory'
      end
    end

    def pull(*)
      Request.perform(url: "#{base_url}#{self.class.api_prefix}", get_vars: { cmd: self.class.history_cmd })[:data]
    end

    def map(json:)
      Item.from_json(json:)
    end

    def app_name
      'Mylar3'
    end

    def app_config
      config.mylar3
    end

    def pull_app_name
      if Request.perform(url: "#{base_url}#{self.class.api_prefix}", get_vars: { cmd: self.class.status_cmd })[
           :data
         ]&.dig(:install_type).present?
        app_name
      else
        'N/A'
      end
    end
  end
end
