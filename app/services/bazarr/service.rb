# frozen_string_literal: true

module Bazarr
  class Service < BaseService
    # TODO: We set this as pagination breaks the ordering
    ITEM_MAX = 5000

    def app_name
      'Bazarr'
    end

    def app_colour
      0x808080 # grey
    end

    private

    class << self
      def api_prefix
        '/api'
      end

      # TODO: we cant use pagination as it breaks the ordering
      # curl -X 'GET' 'https://bazarr/api/episodes/history?length=5000' -H 'accept: application/json' -H 'X-API-KEY: 12345' # rubocop:disable Layout/LineLength
      def episode_history_endpoint
        "#{api_prefix}/episodes/history"
      end
      # curl -X 'GET' 'https://bazarr/api/movies/history?length=5000' -H 'accept: application/json' -H 'X-API-KEY: 12345' # rubocop:disable Layout/LineLength

      def movie_history_endpoint
        "#{api_prefix}/movies/history"
      end
      # curl -X 'GET' 'http://bazarr/api/system/status?apikey=asd'   -H 'accept: application/json'

      def status_endpoint
        "#{api_prefix}/system/status"
      end
    end

    def pull(*)
      (
        Request.perform(url: "#{base_url}#{self.class.episode_history_endpoint}", get_vars:, headers:)[:data] +
          Request.perform(url: "#{base_url}#{self.class.movie_history_endpoint}", get_vars:, headers:)[:data]
      )
    end

    def map(json:)
      Item.from_json(json:)
    end

    def filter(*)
      true
    end

    def get_vars # rubocop:disable Naming/AccessorMethodName
      { length: ITEM_MAX, page: 0 }
    end

    def headers
      { 'X-API-KEY' => api_key }
    end

    def app_config
      config.bazarr
    end

    def pull_app_name
      if Request.perform(url: "#{base_url}#{self.class.status_endpoint}", headers:)[:data]&.dig(
           :bazarr_version
         ).present?
        app_name
      else
        'N/A'
      end
    end
  end
end
