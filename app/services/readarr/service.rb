# frozen_string_literal: true

module Readarr
  class Service < GenericArrService
    # curl -X 'GET' 'http://readarr:8787/api/v1/history?page=1&pageSize=15&includeBook=true&includeAuthor=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    # curl -X 'GET' 'http://readarr:8787/api/v1/system/status?apikey=asd'   -H 'accept: application/json'

    private

    class << self
      def api_version
        'v1'
      end
    end

    def filter(item:)
      Item::EVENT_TYPES.value?(item.event_type)
    end

    def map(json:)
      Item.from_json(json:)
    end

    def get_vars(page: 1)
      super.merge({ includeBook: true, includeAuthor: true })
    end

    def app_name
      'Readarr'
    end

    def app_config
      config.readarr
    end
  end
end
