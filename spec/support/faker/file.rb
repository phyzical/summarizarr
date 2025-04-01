# frozen_string_literal: true

module Faker
  class File < Base
    class << self
      ##
      # Produces a random file size in gigabytes (GB).
      #
      # @param min [Integer] Specifies the minimum file size in GB.
      # @param max [Integer] Specifies the maximum file size in GB.
      # @return [String]
      #
      # @example
      #   Faker::File.filesize_in_gb #=> "3.45 GB"
      #   Faker::File.filesize_in_gb(min: 1, max: 10) #=> "7.89 GB"
      #
      def filesize_in_gb(min: 0.1, max: 5)
        rand(min..max) + rand.round(2) # Random GB size with 2 decimal places
      end
    end
  end
end
