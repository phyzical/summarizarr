# frozen_string_literal: true

module Notifications
  #  TODO: Should these be models?
  module Discord
    class << self
      def notify(contents:)
        pp contents
      end
    end
  end
end
