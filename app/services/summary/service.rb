# frozen_string_literal: true

module Summary
  module Service
    SERVICES = [
      Radarr::Service,
      Sonarr::Service,
      Bazarr::Service,
      Lidarr::Service,
      Mylar3::Service,
      Readarr::Service,
      Tdarr::Service
    ].freeze
    def self.generate
      SERVICES.map { |x| x.new.summary }.join("\n")
    end
  end
end
