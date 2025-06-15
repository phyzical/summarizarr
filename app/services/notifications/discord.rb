# frozen_string_literal: true

module Notifications
  module Discord
    DOT_POINT = '* '

    class << self
      def notify(service:)
        service_notification(service:)
        sleep(0.3)
        return unless service.extra_info?
        service.grouped_items.each do |primary_group, primary_group_items|
          primary_title = primary_group.to_s if primary_group.present?
          primary_group_items.each do |secondary_group, secondary_group_items|
            secondary_title =
              "#{service.class::SECONDARY_GROUP_CONTEXT}: #{secondary_group}" if secondary_group.present?
            items_notification(
              primary_title:,
              items: secondary_group_items.map { |item| "* #{item.summary}" },
              secondary_title:,
              service:
            )
            sleep(0.3)
          end
        end
      end

      private

      def send(color:, primary_title:, secondary_title:, fields: [])
        Request.perform(
          type: :post,
          url: webhook_url,
          headers: {
            'Content-Type' => 'application/json'
          },
          body: {
            content: '',
            username:,
            avatar_url:,
            embeds: [
              {
                title: primary_title,
                description: secondary_title,
                color:,
                fields:,
                footer: {
                  text: ''
                },
                timestamp: DateTime.now.utc.iso8601
              }
            ]
          }
        )
      end

      def service_notification(service:)
        send(
          color: service.class::APP_COLOUR,
          primary_title: "#{service.class::APP_NAME} - #{from_date} -> #{DateTime.now.to_date}",
          fields: [{ name: '', value: service.summary, inline: false }],
          secondary_title: ''
        )
      end

      def items_notification(primary_title:, secondary_title:, items:, service:)
        # max out at 20 items per notification to avoid max size issue
        loop do
          break if items.empty?
          send(
            color: service.class::APP_COLOUR,
            primary_title:,
            secondary_title:,
            fields: items.shift(20).map { |value| { name: '', value:, inline: false } }
          )
        end
      end

      delegate :discord, :from_date, to: :config
      delegate :webhook_url, :username, :avatar_url, to: :discord

      def config
        @config ||= Config.get
      end
    end
  end
end
