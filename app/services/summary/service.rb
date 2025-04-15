# frozen_string_literal: true

module Summary
  module Service
    SERVICES = [
      Tdarr::Service,
      Radarr::Service,
      Sonarr::Service,
      Bazarr::Service,
      Lidarr::Service,
      Mylar3::Service,
      Readarr::Service
    ].freeze
  end
end
