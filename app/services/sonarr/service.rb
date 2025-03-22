# frozen_string_literal: true

module Sonarr
  class Service < BaseService
    # curl -X 'GET' 'http://sonarr:8989/api/v3/history/since?date=2025-03-10&includeEpisode=true&includeSeries=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    SINCE_ENDPOINT = '/api/v3/history/since'
    # curl -X 'GET' 'http://sonarr:8989/api/v3/system/status?apikey=asd'   -H 'accept: application/json'
    STATUS_ENDPOINT = '/api/v3/system/status'

    def items
      @items ||=
        Request
          .perform(
            url: "#{base_url}#{SINCE_ENDPOINT}",
            api_key:,
            get_vars: {
              date: from_date,
              includeEpisode: true,
              includeSeries: true
            }
          )
          .map { |json| Item.from_json(json:) }
          .filter { |item| Item::EVENT_TYPES.value?(item.event_type) }
          .group_by(&:title)
          .map { |title, items| Summary::Item.new(title:, items:) }
    end

    private

    def app_name
      'Sonarr'
    end

    def app_config
      config.sonarr
    end

    def pull_app_name
      Request.perform(url: "#{base_url}#{STATUS_ENDPOINT}", api_key:)[:appName]
    end
  end
end
