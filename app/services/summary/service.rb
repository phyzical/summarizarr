# frozen_string_literal: true

module Summary
  class Service
    SERVICES = [Radarr::Service, Sonarr::Service, Bazarr::Service].freeze
    def generate
      SERVICES.map { |x| x.new.summary }.join("\n")
    end
  end
end
