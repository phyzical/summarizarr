# frozen_string_literal: true

module Bazarr
  module Item
    ATTRIBUTES = {
      language: :language,
      seriesTitle: :series,
      episode: :episode,
      season: :season,
      description: :description,
      date: :date,
      score: :score,
      title: :title
    }.freeze

    def self.from_json(json:)
      json[:language] = json[:language][:name]
      json[:title] = json[:episodeTitle] || json[:title]
      if json[:episode_number].present?
        splits = json[:episode_number].split('x')
        json[:episode] = splits.last.to_i
        json[:season] = splits.first.to_i
      end
      json[:date] = DateTime.strptime(json[:parsed_timestamp], '%m/%d/%y %H:%M:%S').to_date
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          text = ''
          text = "Ep: #{episode} - " if episode.present?
          "#{text}#{title}: #{description}"
        end
      end
  end
end
