# frozen_string_literal: true

module Readarr
  module Item
    EVENT_TYPES = { book_file_imported: 'bookFileImported', book_file_deleted: 'bookFileDeleted' }.freeze

    ATTRIBUTES = {
      eventType: :event_type,
      image: :image,
      author_image: :author_image,
      author: :author,
      deletion?: :deletion?,
      quality: :quality,
      old_quality: :old_quality,
      title: :title,
      date: :date
    }.freeze

    def self.from_json(json:) # rubocop:disable Metrics/AbcSize
      if json[:book].present?
        json[:title] = json[:book][:title]
        json[:image] = json[:book][:images].pluck(:url).first
      end
      if json[:author].present?
        json[:author_image] = json[:author][:images].pluck(:url).first
        json[:author] = json[:author][:authorName]
      end
      json[:deletion?] = json[:data][:reason] == 'Upgrade'
      json[:quality] = json[:quality][:quality][:name]
      json[:date] = DateTime.parse(json[:date]).to_date
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
