# frozen_string_literal: true

module Sonarr
  class Service
    def initialize
      items
    end
    # curl -X 'GET' 'http://192.168.69.111:8989/api/v3/history/since?date=2025-03-10&includeEpisode=true&includeSeries=true&apikey=asd'   -H 'accept: application/json' # rubocop:disable Layout/LineLength
    SINCE_ENDPOINT = '/api/v3/history/since'

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
          .map { |title, items| Summary.new(title:, items:) }
    end

    private

    delegate :from_date, to: :config
    delegate :base_url, :api_key, to: :app_config

    def config
      @config ||= Config.get
    end

    def app_config
      config.sonarr
    end
  end
end
