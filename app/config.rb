# frozen_string_literal: true

module Config
  def self.get
    @get ||= Thing.new
  end

  AppConfig =
    Struct.new(:base_url, :api_key, :extra_info) do
      def extra_info?
        extra_info == 'true'
      end
    end
  NotificationConfig = Struct.new(:webhook_url, :enabled?, :username, :avatar_url)

  Thing =
    Struct.new do
      def debug?
        ENV.fetch('DEBUG', 'false') == 'true'
      end

      def from_date
        ENV.fetch('SUMMARY_DAYS', '7').to_i.days.ago.to_date
      end

      def rerun_datetime
        interval = ENV.fetch('RERUN_INTERVAL_DAYS', '')
        return nil if interval.empty?
        DateTime.now + interval.to_i.days
      end

      def sonarr
        AppConfig.new(
          base_url: ENV.fetch('SONARR_URL', 'http://sonarr:8989'),
          api_key: ENV.fetch('SONARR_API_KEY', '12345'),
          extra_info: ENV.fetch('SONARR_EXTRA_INFO', 'false')
        )
      end

      def radarr
        AppConfig.new(
          base_url: ENV.fetch('RADARR_URL', 'http://radarr:7878'),
          api_key: ENV.fetch('RADARR_API_KEY', '12345'),
          extra_info: ENV.fetch('RADARR_EXTRA_INFO', 'false')
        )
      end

      def lidarr
        AppConfig.new(
          base_url: ENV.fetch('LIDARR_URL', 'http://lidarr:8686'),
          api_key: ENV.fetch('LIDARR_API_KEY', '12345'),
          extra_info: ENV.fetch('LIDARR_EXTRA_INFO', 'false')
        )
      end

      def readarr
        AppConfig.new(
          base_url: ENV.fetch('READARR_URL', 'http://readarr:8787'),
          api_key: ENV.fetch('READARR_API_KEY', '12345'),
          extra_info: ENV.fetch('READARR_EXTRA_INFO', 'false')
        )
      end

      def mylar3
        AppConfig.new(
          base_url: ENV.fetch('MYLAR3_URL', 'http://mylar3:8090'),
          api_key: ENV.fetch('MYLAR3_API_KEY', '12345'),
          extra_info: ENV.fetch('MYLAR3_EXTRA_INFO', 'false')
        )
      end

      def bazarr
        AppConfig.new(
          base_url: ENV.fetch('BAZARR_URL', 'http://bazarr:6767'),
          api_key: ENV.fetch('BAZARR_API_KEY', '12345'),
          extra_info: ENV.fetch('BAZARR_EXTRA_INFO', 'false')
        )
      end

      def tdarr
        AppConfig.new(
          base_url: ENV.fetch('TDARR_URL', 'http://tdarr:8266'),
          api_key: '',
          extra_info: ENV.fetch('TDARR_EXTRA_INFO', 'false')
        )
      end

      def notify_upgraded_items?
        ENV.fetch('ENABLE_UPGRADED_ITEMS', 'true') == 'true'
      end

      def discord
        webhook_url = ENV.fetch('DISCORD_WEBHOOK_URL', nil)
        NotificationConfig.new(
          webhook_url:,
          enabled?: webhook_url.present?,
          username: ENV.fetch('DISCORD_USERNAME', 'Summarizarr Bot'),
          avatar_url: ENV.fetch('DISCORD_AVATAR_URL', 'https://github.com/phyzical/summarizarr/blob/main/icon.png')
        )
      end
    end
end
