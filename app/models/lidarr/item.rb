# frozen_string_literal: true

module Lidarr
  module Item
    EVENT_TYPES = { track_file_imported: 'trackFileImported', track_file_deleted: 'trackFileDeleted' }.freeze

    ATTRIBUTES = {
      eventType: :event_type,
      image: :image,
      album: :album,
      artist: :artist,
      deletion?: :deletion?,
      quality: :quality,
      old_quality: :old_quality,
      title: :title,
      date: :date
    }.freeze

    def self.from_json(json:) # rubocop:disable Metrics/AbcSize
      json[:title] = json[:track]&.dig(:title)
      json[:album] = json[:album][:title]
      json[:image] = json[:artist][:images].pluck(:url).first
      json[:artist] = json[:artist][:artistName]
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
