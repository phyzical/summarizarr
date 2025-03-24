# frozen_string_literal: true

module Config
  def self.get
    @get ||= Thing.new
  end

  AppConfig = Struct.new(:base_url, :api_key)

  Thing =
    Struct.new do
      def from_date
        @from_date ||= ENV.fetch('SUMMARY_DAYS', '7').to_i.days.ago.to_date
      end

      def sonarr
        @sonarr ||=
          AppConfig.new(
            base_url: ENV.fetch('SONARR_URL', 'http://sonarr:8989'),
            api_key: ENV.fetch('SONARR_API_KEY', '12345')
          )
      end

      def radarr
        @radarr ||=
          AppConfig.new(
            base_url: ENV.fetch('RADARR_URL', 'http://radarr:7878'),
            api_key: ENV.fetch('RADARR_API_KEY', '12345')
          )
      end

      def bazarr
        @bazarr ||=
          AppConfig.new(
            base_url: ENV.fetch('BAZARR_URL', 'http://bazarr:6767'),
            api_key: ENV.fetch('BAZARR_API_KEY', '12345')
          )
      end
    end
end
