# frozen_string_literal: true

module Bazarr
  class Service < BaseService
    APP_NAME = 'Bazarr'
    APP_COLOUR = 0x808080 # grey
    ITEM_SORT_CONTEXT = :episode

    def summary
      "* Processed #{items.count} subtitles\n"
    end

    private

    class << self
      def api_prefix
        '/api'
      end

      # curl -X 'GET' 'https://bazarr/api/episodes/?start=0&length=15' -H 'accept: application/json' -H 'X-API-KEY: 12345' # rubocop:disable Layout/LineLength
      def episode_history_endpoint
        "#{api_prefix}/episodes/history"
      end
      # curl -X 'GET' 'https://bazarr/api/movies/history?start=0&length=15' -H 'accept: application/json' -H 'X-API-KEY: 12345' # rubocop:disable Layout/LineLength

      def movie_history_endpoint
        "#{api_prefix}/movies/history"
      end
      # curl -X 'GET' 'http://bazarr/api/system/status?apikey=asd'   -H 'accept: application/json'

      def status_endpoint
        "#{api_prefix}/system/status"
      end
    end

    def pulls(page: 1)
      page -= 1
      get_vars = get_vars(page:)
      [
        Request.perform(url: "#{base_url}#{self.class.episode_history_endpoint}", get_vars:, headers:)[:data],
        Request.perform(url: "#{base_url}#{self.class.movie_history_endpoint}", get_vars:, headers:)[:data]
      ]
    end

    def filter(*) # rubocop:disable Naming/PredicateMethod
      true
    end

    def get_vars(page: 1)
      { length: PAGE_SIZE, start: page * PAGE_SIZE }
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
        APP_NAME
      else
        'N/A'
      end
    end
  end
end
