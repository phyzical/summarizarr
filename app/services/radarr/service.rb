# frozen_string_literal: true

module Radarr
  class Service < GenericArrService
    # curl -X 'GET' 'http://radarr:7878/api/v3/history?page=1&pageSize=15&includeMovie=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    # curl -X 'GET' 'http://radarr:7878/api/v3/system/status?apikey=asd'   -H 'accept: application/json'

    APP_NAME = 'Radarr'
    APP_COLOUR = 0x800080 # purple

    private

    def map(json:)
      Item.from_json(json:)
    end

    def get_vars(page: 1)
      super.merge({ includeMovie: true })
    end

    def app_config
      config.radarr
    end
  end
end
