# frozen_string_literal: true

module Sonarr
  class Service < GenericArrService
    # curl -X 'GET' 'http://sonarr:8989/api/v3/history?page=1&pageSize=15&includeEpisode=true&includeSeries=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    # curl -X 'GET' 'http://sonarr:8989/api/v3/system/status?apikey=asd'   -H 'accept: application/json'

    APP_NAME = 'Sonarr'
    APP_COLOUR = 0xFF0000 # red
    ITEM_SORT_CONTEXT = :episode

    def summary
      [
        "* Processed #{items.count} episodes from #{grouped_items.keys.count} series",
        "* Total Upgrades: #{items.count(&:upgrade?)}"
      ].join("\n")
    end

    private

    def get_vars(page: 1)
      super.merge({ includeEpisode: true, includeSeries: true })
    end

    def app_config
      config.sonarr
    end
  end
end
