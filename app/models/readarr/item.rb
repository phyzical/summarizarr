# frozen_string_literal: true

module Readarr
  module Item
    EVENT_TYPES = { book_file_imported: 'bookFileImported', book_file_deleted: 'bookFileDeleted' }.freeze

    ATTRIBUTES = {
      eventType: :event_type,
      image: :image,
      author: :author,
      deletion?: :deletion?,
      quality: :quality,
      old_quality: :old_quality,
      title: :title
    }.freeze

    def self.from_json(json:)
      json[:title] = json[:sourceTitle]
      # TODO: add an issue on readarr about includeBook having no effect
      # json[:track] = json[:track]&.dig(:title)
      if json[:author]
        json[:image] = json[:author][:images].pluck(:url).first
        json[:author] = json[:author][:authorName]
      end
      json[:deletion?] = json[:data][:reason] == 'Upgrade'
      json[:quality] = json[:quality][:quality][:name]
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          if old_quality.present?
            "#{title} has upgraded from #{old_quality} to #{quality}"
          else
            "#{title} has downloaded at #{quality}"
          end
        end
      end
  end
end
