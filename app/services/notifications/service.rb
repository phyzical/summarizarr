# frozen_string_literal: true

module Notifications
  module Service
    class << self
      def notify(services: Summary::Service::SERVICES)
        notifier = (discord.enabled? ? Discord : Generic)
        services.map(&:new).each { |service| notifier.notify(service:) }
      end

      private

      delegate :discord, to: :config

      def config
        @config ||= Config.get
      end
    end
  end
end
