# frozen_string_literal: true

module Mylar3
  class Service < BaseService
    # curl -X 'GET' 'http://mylar3:8090/api?cmd=getHistory&apikey=asd'   -H 'accept: application/json'
    # curl -X 'GET' 'http://mylar3:8090/api?cmd=getVersion&apikey=asd'   -H 'accept: application/json'

    APP_NAME = 'Mylar3'
    APP_COLOUR = 0xFFFF00 # yellow

    PRIMARY_GROUP_CONTEXT = :comic
    SECONDARY_GROUP_CONTEXT = nil

    def summary
      "* Processed #{items.count} issues from #{grouped_items.keys.count} comics\n"
    end

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
      Request.perform(url: "#{base_url}#{self.class.api_prefix}", get_vars: get_vars(cmd: self.class.history_cmd))[
        :data
      ]
    end

    def app_config
      config.mylar3
    end

    def get_vars(cmd:)
      { cmd:, apikey: app_config.api_key }
    end

    def pull_app_name
      if Request.perform(url: "#{base_url}#{self.class.api_prefix}", get_vars: get_vars(cmd: self.class.status_cmd))[
           :data
         ]&.dig(:install_type).present?
        APP_NAME
      else
        'N/A'
      end
    end
  end
end
