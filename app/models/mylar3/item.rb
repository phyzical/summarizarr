# frozen_string_literal: true

module Mylar3
  module Item
    EVENT_TYPES = { post_processed: 'Post-Processed' }.freeze

    ATTRIBUTES = {
      Status: :event_type,
      deletion?: :deletion?,
      DateAdded: :date,
      ComicName: :comic,
      Issue_Number: :issue
    }.freeze

    def self.from_json(json:)
      json[:DateAdded] = DateTime.parse(json[:DateAdded]).to_date
      json[:deletion?] = false
      json[:Issue_Number] = json[:Issue_Number].to_i
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          "issue: #{issue} has downloaded"
        end

        def upgrade?
          false
        end
      end
  end
end
