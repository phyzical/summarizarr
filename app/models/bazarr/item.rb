# frozen_string_literal: true

module Bazarr
  module Item
    ATTRIBUTES = {
      language: :language,
      seriesTitle: :series,
      episode_number: :episode_number,
      description: :description,
      date: :date,
      score: :score,
      title: :title
    }.freeze

    def self.from_json(json:)
      json[:language] = json[:language][:name]
      json[:title] = json[:episodeTitle] || json[:title]
      json[:date] = DateTime.strptime(json[:parsed_timestamp], '%m/%d/%y %H:%M:%S').strftime('%d/%m/%Y')
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          "#{title}: #{description}"
        end
      end
  end
end
