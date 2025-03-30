# frozen_string_literal: true

module Notifications
  module Service
    class << self
      def notify(contents:)
        discord.enabled? ? Discord::Notification.notify(contents:) : Generic::Notification.notify(contents:)
      end

      private

      delegate :discord, to: :config

      def config
        @config ||= Config.get
      end
    end
  end
end
