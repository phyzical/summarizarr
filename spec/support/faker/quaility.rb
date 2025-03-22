# frozen_string_literal: true

module Faker
  class Quality < Base
    QUALITIES = %w[CAM TS SD HD WEB-DL WEBRip HDRip BluRay DVD DVDRip HDTV 480p 720p 1080p 1440p 4K 8K].freeze

    class << self
      def name
        sample(QUALITIES)
      end
    end
  end
end
