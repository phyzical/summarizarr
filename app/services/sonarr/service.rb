# frozen_string_literal: true

module Sonarr
  class Service < GenericArrService
    API_VERSION = 'v3'
    # curl -X 'GET' 'http://sonarr:8989/api/v3/history/since?date=2025-03-10&includeEpisode=true&includeSeries=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    # curl -X 'GET' 'http://sonarr:8989/api/v3/system/status?apikey=asd'   -H 'accept: application/json'

    private

    def filter(item:)
      Item::EVENT_TYPES.value?(item.event_type)
    end

    def map(json:)
      Item.from_json(json:)
    end

    def get_vars # rubocop:disable Naming/AccessorMethodName
      { date: from_date, includeEpisode: true, includeSeries: true }
    end

    def app_name
      'Sonarr'
    end

    def app_config
      config.sonarr
    end
  end
end
