# frozen_string_literal: true

module Mylar3
  module Item
    EVENT_TYPES = { post_processed: 'Post-Processed' }.freeze

    ATTRIBUTES = { Status: :event_type, deletion?: :deletion?, title: :title, date: :date }.freeze

    def self.from_json(json:)
      # TODO: use additional api calls to get comic and issue info i.e images
      # Or make a pr to add includeIssue and includeComic to the api call
      json[:title] = "#{json[:ComicName]} #{json[:Issue_Number]}"
      json[:date] = DateTime.parse(json[:DateAdded]).to_date
      json[:deletion?] = false
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          "#{title} has downloaded"
        end
      end
  end
end
