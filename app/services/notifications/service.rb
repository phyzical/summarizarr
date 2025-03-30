# frozen_string_literal: true

module Notifications
  module Service
    class << self
      def notify(contents:)
        @notify ||= discord.enabled? ? Discord : Generic
        @notify.notify(contents:)
      end

      private

      delegate :discord, to: :config

      def config
        @config ||= Config.get
      end
    end
  end
end
