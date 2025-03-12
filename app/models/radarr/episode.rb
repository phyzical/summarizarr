# frozen_string_literal: true

module Radarr
  # curl -X 'GET' 'http://192.168.69.111:8989/api/v3/history/since?date=2025-03-10&page=1&pageSize=10&includeMovie=true&apikey=asd'   -H 'accept: application/json'

  # if both of these assume upgrade i  "eventType": "episodeFileDeleted", and "eventType": "downloadFolderImported",
  #  if only downloadFolderImported then must be new
  module Episode
    ATTRIBUTES = {
      eventType: :event_type,
      languages: :languages,
      title: :title,
      image: :image,
      overview: :overview,
      upgrade?: :upgrade?,
      quality: :quality
    }.freeze

    def self.from_json(json:)
      json[:title] = json[:movie][:title]
      json[:image] = json[:movie][:images].pluck(:remoteUrl).first
      json[:overview] = json[:movie][:overview]
      json[:languages] = json[:languages].pluck(:name).join(', ')
      json[:upgrade?] = json[:data][:reason] == 'Upgrade'
      json[:quality] = json[:quality][:quality][:name]
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing = Struct.new(*ATTRIBUTES.values)
  end
end
