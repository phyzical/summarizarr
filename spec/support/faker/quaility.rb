# frozen_string_literal: true

module Faker
  class Quality < Base
    TV_QUALITIES = %w[CAM TS SD HD WEB-DL WEBRip HDRip BluRay DVD DVDRip HDTV 480p 720p 1080p 1440p 4K 8K].freeze
    MUSIC_QUALITIES = %w[MP3 AAC FLAC WAV ALAC OGG WMA AIFF DSD 128kbps 192kbps 256kbps 320kbps Lossless Hi-Res].freeze

    class << self
      def tv
        sample(TV_QUALITIES)
      end

      def music
        sample(MUSIC_QUALITIES)
      end
    end
  end
end
