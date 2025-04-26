# frozen_string_literal: true

module Notifications
  module Generic
    class << self
      SEPARATOR =
        "\n----------------------------------------------------------------------------------------------------\n"
      DOT_POINT = '* '

      def notify(service:)
        puts "#{SEPARATOR}#{service.class::APP_NAME}"
        puts service.summary
        service.grouped_items.each do |primary_group, primary_group_items|
          puts "#{SEPARATOR}#{service.class::PRIMARY_GROUP_CONTEXT}: #{primary_group}"
          primary_group_items.each do |secondary_group, secondary_group_items|
            puts "#{service.class::SECONDARY_GROUP_CONTEXT}: #{secondary_group}"
            secondary_group_items.each do |fallback_group, fallback_group_items|
              puts "#{service.class::FALLBACK_GROUP_CONTEXT}: #{fallback_group}"
              fallback_group_items.each { |item| puts "#{DOT_POINT}#{item.summary}" }
            end
          end
        end
      end
    end
  end
end
