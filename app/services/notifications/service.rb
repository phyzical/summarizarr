# frozen_string_literal: true

module Notifications
  class Service
    def notify(contents:)
      @notify ||= discord.enabled? ? Discord.new : Generic.new
      @notify.notify(contents:)
    end

    private

    delegate :discord, to: :config

    def config
      @config ||= Config.get
    end
  end
end
