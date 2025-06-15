# frozen_string_literal: true

module Sonarr
  module Item
    EVENT_TYPES = {
      download_folder_imported: 'downloadFolderImported',
      episode_file_deleted: 'episodeFileDeleted'
    }.freeze

    ATTRIBUTES = {
      eventType: :event_type,
      languages: :languages,
      series: :series,
      title: :title,
      overview: :overview,
      image: :image,
      deletion?: :deletion?,
      quality: :quality,
      old_quality: :old_quality,
      episode: :episode,
      season: :season,
      date: :date
    }.freeze

    def self.from_json(json:) # rubocop:disable Metrics/AbcSize
      json[:image] = json[:series][:images].pluck(:remoteUrl).first
      json[:series] = json[:series][:title]
      json[:season] = json[:episode][:seasonNumber]
      json[:title] = json[:episode][:title]
      json[:overview] = json[:episode][:overview]
      json[:episode] = json[:episode][:episodeNumber]
      json[:languages] = json[:languages].pluck(:name).join(', ')
      json[:deletion?] = %w[Upgrade Manual].include?(json[:data][:reason])
      json[:quality] = json[:quality][:quality][:name]
      json[:date] = DateTime.parse(json[:date]).to_date
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          text = "Ep: #{episode} - #{title}"
          upgrade? ? "#{text} has upgraded from #{old_quality} to #{quality}" : "#{text} has downloaded at #{quality}"
        end

        def upgrade?
          old_quality.present?
        end
      end
  end
end
