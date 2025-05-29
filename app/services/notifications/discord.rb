# frozen_string_literal: true

module Notifications
  module Discord
    DOT_POINT = '* '

    class << self
      def notify(service:)
        service_notification(service:)
        sleep(0.3)
        service.grouped_items.each do |primary_group, primary_group_items|
          primary_title = primary_group.present? ? "#{service.class::PRIMARY_GROUP_CONTEXT}: #{primary_group}" : ''
          primary_group_items.each do |secondary_group, secondary_group_items|
            #  TODO: can we combine each secondary group?
            secondary_group_items.each do |fallback_group, fallback_group_items|
              secondary_title = [
                secondary_group.present? ? "#{service.class::SECONDARY_GROUP_CONTEXT}: #{secondary_group}" : nil,
                "#{service.class::FALLBACK_GROUP_CONTEXT}: #{fallback_group}"
              ].compact.join("\n")
              items_notification(
                primary_title:,
                items: fallback_group_items.map { |item| "* #{item.summary}" },
                secondary_title:,
                service:
              )
              sleep(0.3)
            end
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
        send(
          color: service.class::APP_COLOUR,
          primary_title:,
          secondary_title:,
          fields: items.map { |value| { name: '', value:, inline: false } }
        )
      end

      # def summary_chunks(grouped_items:)
      #   grouped_items.each do |date, date_items|
      #     grouped_items[date] = date_items
      #       .reduce('') { |acc, item| acc + "* #{item.summary}\n" }
      #       .split("\n")
      #       .each_with_object([+'']) do |line, slices|
      #         if (slices.last.length + line.length + 1) <= 1000
      #           slices.last << "\n" unless slices.last.empty?
      #           slices.last << line
      #         else
      #           slices << line
      #         end
      #       end
      #       .each_slice(6)
      #       .to_a
      #   end
      #   grouped_items
      # end

      delegate :discord, :from_date, to: :config
      delegate :webhook_url, :username, :avatar_url, to: :discord

      def config
        @config ||= Config.get
      end
    end
  end
end
