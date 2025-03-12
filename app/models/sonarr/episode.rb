# frozen_string_literal: true

module Sonarr
  # curl -X 'GET' 'http://192.168.69.111:8989/api/v3/history/since?date=2025-03-10&page=1&pageSize=10&includeEpisode=true&includeSeries=true&apikey=asd'   -H 'accept: application/json'

  # if both of these assume upgrade i  "eventType": "episodeFileDeleted", and "eventType": "downloadFolderImported",
  #  if only downloadFolderImported then must be new
  module Episode
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
