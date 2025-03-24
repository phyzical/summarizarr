# frozen_string_literal: true

module Radarr
  module Item
    EVENT_TYPES = { download_folder_imported: 'downloadFolderImported', movie_file_deleted: 'movieFileDeleted' }.freeze

    ATTRIBUTES = {
      eventType: :event_type,
      languages: :languages,
      title: :title,
      image: :image,
      overview: :overview,
      deletion?: :deletion?,
      quality: :quality,
      old_quality: :old_quality
    }.freeze

    def self.from_json(json:)
      json[:title] = json[:movie][:title]
      json[:image] = json[:movie][:images].pluck(:remoteUrl).first
      json[:overview] = json[:movie][:overview]
      json[:languages] = json[:languages].pluck(:name).join(', ')
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
