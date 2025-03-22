# frozen_string_literal: true

module Sonarr
  # if both of these assume upgrade i  "eventType": "episodeFileDeleted", and "eventType": "downloadFolderImported",
  #  if only downloadFolderImported then must be new
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
      series_image: :series_image,
      upgrade?: :upgrade?,
      quality: :quality
    }.freeze

    def self.from_json(json:) # rubocop:disable Metrics/AbcSize
      json[:series_image] = json[:series][:images].pluck(:remoteUrl).first
      json[:series] = json[:series][:title]
      json[:title] = json[:episode][:title]
      json[:overview] = json[:episode][:overview]
      json[:languages] = json[:languages].pluck(:name).join(', ')
      json[:upgrade?] = json[:data][:reason] == 'Upgrade'
      json[:quality] = json[:quality][:quality][:name]
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing = Struct.new(*ATTRIBUTES.values)
  end
end
