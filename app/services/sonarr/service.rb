# frozen_string_literal: true

module Sonarr
  class Service < GenericArrService
    API_VERSION = 'v3'
    # curl -X 'GET' 'http://sonarr:8989/api/v3/history?page=1&pageSize=15&includeEpisode=true&includeSeries=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    # curl -X 'GET' 'http://sonarr:8989/api/v3/system/status?apikey=asd'   -H 'accept: application/json'

    def app_name
      'Sonarr'
    end

    def app_colour
      0xFF0000 # red
    end

    private

    def map(json:)
      Item.from_json(json:)
    end

    def get_vars(page: 1)
      super.merge({ includeEpisode: true, includeSeries: true })
    end

    def app_config
      config.sonarr
    end
  end
end
