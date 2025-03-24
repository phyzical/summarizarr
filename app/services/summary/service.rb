# frozen_string_literal: true

module Summary
  module Service
    SERVICES = [Radarr::Service, Sonarr::Service, Bazarr::Service].freeze
    class << self
      def generate
        SERVICES.map { |x| x.new.summary }.join("\n")
      end
    end
  end
end
