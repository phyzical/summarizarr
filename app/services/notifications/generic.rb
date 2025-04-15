# frozen_string_literal: true

module Notifications
  module Generic
    class << self
      SEPARATOR =
        "\n----------------------------------------------------------------------------------------------------\n"
      DOT_POINT = "\n* "

      def notify(service:)
        pp "#{SEPARATOR}#{service.app_name}"
        pp service.summary
        service.grouped_items.each do |date, date_items|
          pp "#{SEPARATOR}#{date}"
          date_items.each { |item| pp "#{DOT_POINT} #{item.summary}" }
        end
      end
    end
  end
end
