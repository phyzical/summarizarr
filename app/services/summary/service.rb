# frozen_string_literal: true

module Summary
  module Service
    class << self
      def generate
        [Radarr::Service.new, Sonarr::Service.new].map(&:summary).join("\n")
      end
    end
  end
end
