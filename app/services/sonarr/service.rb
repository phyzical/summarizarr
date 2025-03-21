# frozen_string_literal: true

module Sonarr
  class Service
    def initialize
      items
    end

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
          .map { |json| Episode.from_json(json:) }
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
