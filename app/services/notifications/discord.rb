# frozen_string_literal: true

module Notifications
  #  TODO: Should these be models?
  module Discord
    class << self
      def notify(contents:)
        Request.post(
          url: config.webhook_url,
          headers: {
            'Content-Type' => 'application/json'
          },
          body: {
            content: contents,
            username: config.username,
            avatar_url: config.avatar_url
            # embeds: [
            #   {
            #     title: contents[:title],
            #     description: contents[:description],
            #     color: contents[:color],
            #     fields: contents[:fields],
            #     footer: {
            #       text: contents[:footer_text],
            #       icon_url: contents[:footer_icon_url]
            #     },
            #     timestamp: Time.now.utc.iso8601
            #   }
            # ]
          }.to_json
        )
      end
    end
  end
end
