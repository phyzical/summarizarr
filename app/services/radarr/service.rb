# frozen_string_literal: true

module Radarr
  class Service < BaseService
    API_PREFIX = '/api/v3'
    # curl -X 'GET' 'http://radarr:7878/api/v3/history/since?date=2025-03-10&includeMovie=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    SINCE_ENDPOINT = "#{API_PREFIX}/history/since".freeze
    # curl -X 'GET' 'http://radarr:7878/api/v3/system/status?apikey=asd'   -H 'accept: application/json'
    STATUS_ENDPOINT = "#{API_PREFIX}/system/status".freeze

    def items
      @items ||=
        combine_items(
          Request
            .perform(url: "#{base_url}#{SINCE_ENDPOINT}", headers:, get_vars: { date: from_date, includeMovie: true })
            .map { |json| Item.from_json(json:) }
            .filter { |item| Item::EVENT_TYPES.value?(item.event_type) }
        )
    end

    private

    def combine_items(combinable_items)
      combinable_items
        .group_by(&:title)
        .values
        .map do |items|
          old = items.find(&:deletion?)
          new = items.reject(&:deletion?).first
          new.old_quality = old.quality if old
          new
        end
    end

    def headers
      { Authorization: "Bearer #{api_key}" }
    end

    def app_name
      'Radarr'
    end

    def app_config
      config.radarr
    end

    def pull_app_name
      Request.perform(url: "#{base_url}#{STATUS_ENDPOINT}", headers:)[:appName]
    end
  end
end
