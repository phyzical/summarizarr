# frozen_string_literal: true

module Lidarr
  module Item
    EVENT_TYPES = { track_file_imported: 'trackFileImported', track_file_deleted: 'trackFileDeleted' }.freeze

    ATTRIBUTES = {
      eventType: :event_type,
      image: :image,
      album: :album,
      track: :track,
      artist: :artist,
      deletion?: :deletion?,
      quality: :quality,
      old_quality: :old_quality,
      title: :title
    }.freeze

    def self.from_json(json:) # rubocop:disable Metrics/AbcSize
      json[:track] = json[:sourceTitle]
      # TODO: https://github.com/Lidarr/Lidarr/issues/5421
      # json[:track] = json[:track]&.dig(:title)
      json[:album] = json[:album]&.dig(:title)
      json[:title] = json[:track] || json[:album]
      if json[:artist]
        json[:image] = json[:artist][:images].pluck(:url).first
        json[:artist] = json[:artist][:artistName]
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
