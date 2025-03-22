# frozen_string_literal: true

module Faker
  class Language < Base
    LANGUAGES = %w[English Spanish French German Chinese Japanese Russian Arabic Hindi Portuguese].freeze

    class << self
      def name
        sample(LANGUAGES)
      end
    end
  end
end
