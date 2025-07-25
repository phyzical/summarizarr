# frozen_string_literal: true

module Config
  def self.get
    @get ||= Thing.new
  end

  AppConfig = Struct.new(:base_url, :api_key)
  NotificationConfig = Struct.new(:webhook_url, :enabled?, :username, :avatar_url)

  Thing =
    Struct.new do
      def from_date
        @from_date ||= ENV.fetch('SUMMARY_DAYS', '7').to_i.days.ago.to_date
      end

      def rerun_datetime
        interval = ENV.fetch('RERUN_INTERVAL_DAYS', '')
        return nil if interval.empty?
        @rerun_datetime ||= DateTime.now + interval.to_i.days
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

      def lidarr
        @lidarr ||=
          AppConfig.new(
            base_url: ENV.fetch('LIDARR_URL', 'http://lidarr:8686'),
            api_key: ENV.fetch('LIDARR_API_KEY', '12345')
          )
      end

      def readarr
        @readarr ||=
          AppConfig.new(
            base_url: ENV.fetch('READARR_URL', 'http://readarr:8787'),
            api_key: ENV.fetch('READARR_API_KEY', '12345')
          )
      end

      def mylar3
        @mylar3 ||=
          AppConfig.new(
            base_url: ENV.fetch('MYLAR3_URL', 'http://mylar3:8090'),
            api_key: ENV.fetch('MYLAR3_API_KEY', '12345')
          )
      end

      def bazarr
        @bazarr ||=
          AppConfig.new(
            base_url: ENV.fetch('BAZARR_URL', 'http://bazarr:6767'),
            api_key: ENV.fetch('BAZARR_API_KEY', '12345')
          )
      end

      def tdarr
        @tdarr ||= AppConfig.new(base_url: ENV.fetch('TDARR_URL', 'http://tdarr:8266'), api_key: '')
      end

      def discord
        return @discord if @discord
        webhook_url = ENV.fetch('DISCORD_WEBHOOK_URL', nil)
        @discord =
          NotificationConfig.new(
            webhook_url:,
            enabled?: webhook_url.present?,
            username: ENV.fetch('DISCORD_USERNAME', 'Summarizarr Bot'),
            avatar_url: ENV.fetch('DISCORD_AVATAR_URL', 'https://github.com/phyzical/summarizarr/blob/main/icon.png')
          )
      end
    end
end
