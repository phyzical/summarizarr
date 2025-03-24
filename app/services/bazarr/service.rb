# frozen_string_literal: true

module Bazarr
  class Service < BaseService
    API_PREFIX = '/api'

    # curl -X 'GET' 'https://bazarr/api/episodes/history?length=-1' -H 'accept: application/json' -H 'X-API-KEY: 12345'
    EPISODE_HISTORY_ENDPOINT = "#{API_PREFIX}/episodes/history".freeze
    # curl -X 'GET' 'https://bazarr/api/movies/history?length=-1' -H 'accept: application/json' -H 'X-API-KEY: 12345'
    MOVIE_HISTORY_ENDPOINT = "#{API_PREFIX}/movies/history".freeze
    # curl -X 'GET' 'http://bazarr/api/system/status?apikey=asd'   -H 'accept: application/json'
    STATUS_ENDPOINT = "#{API_PREFIX}/system/status".freeze
    # We set this as pagination breaks the ordering
    ITEM_MAX = 5000

    def items
      return @items if @items.present?

      (
        Request.perform(url: "#{base_url}#{EPISODE_HISTORY_ENDPOINT}", get_vars:, headers:)[:data] +
          Request.perform(url: "#{base_url}#{MOVIE_HISTORY_ENDPOINT}", get_vars:, headers:)[:data]
      ).map { |json| Item.from_json(json:) }.reject { |item| item.parsed_timestamp >= from_date }
    end

    private

    def get_vars # rubocop:disable Naming/AccessorMethodName
      { length: ITEM_MAX, page: 0 }
    end

    def headers
      { 'X-API-KEY' => api_key }
    end

    def app_name
      'Bazarr'
    end

    def app_config
      config.sonarr
    end

    def pull_app_name
      Request.perform(url: "#{base_url}#{STATUS_ENDPOINT}", api_key:)[:bazarr_version].present? ? app_name : 'N/A'
    end
  end
end
