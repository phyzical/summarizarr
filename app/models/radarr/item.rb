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
      old_quality: :old_quality,
      date: :date
    }.freeze

    def self.from_json(json:) # rubocop:disable Metrics/AbcSize
      json[:title] = json[:movie][:title]
      json[:image] = json[:movie][:images].pluck(:remoteUrl).first
      json[:overview] = json[:movie][:overview]
      json[:languages] = json[:languages].pluck(:name).join(', ')
      json[:deletion?] = %w[Upgrade Manual].include?(json[:data][:reason])
      json[:quality] = json[:quality][:quality][:name]
      json[:date] = DateTime.parse(json[:date]).to_date
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          upgrade? ? "#{title} has upgraded from #{old_quality} to #{quality}" : "#{title} has downloaded at #{quality}"
        end

        def upgrade?
          old_quality.present?
        end
      end
  end
end
