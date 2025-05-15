# frozen_string_literal: true

module Lidarr
  class Service < GenericArrService
    # curl -X 'GET' 'http://lidarr:8686/api/v1/history?page=1&pageSize=15&includeTrack=true&includeAlbum=true&includeArtist=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    # curl -X 'GET' 'http://lidarr:8686/api/v1/system/status?apikey=asd'   -H 'accept: application/json'

    APP_NAME = 'Lidarr'
    APP_COLOUR = 0xFFA500 # orange
    PRIMARY_GROUP_CONTEXT = :artist
    SECONDARY_GROUP_CONTEXT = :album

    def summary
      "* Processed #{items.count} songs from #{grouped_items.keys.count} artists\n"
    end

    private

    class << self
      def api_version
        'v1'
      end
    end

    def get_vars(page: 1)
      super.merge({ includeAlbum: true, includeArtist: true, includeTrack: true })
    end

    def app_config
      config.lidarr
    end
  end
end
