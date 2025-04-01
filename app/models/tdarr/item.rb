# frozen_string_literal: true

module Tdarr
  module Item
    EVENT_TYPES = { transcode_success: 'Transcode success' }.freeze

    ATTRIBUTES = {
      status: :event_type,
      fileSizeStartGB: :size_before,
      fileSizeEndGB: :size_after,
      fileSizeRatio: :size_ratio,
      file: :title,
      deletion?: :deletion?,
      date: :date
    }.freeze

    def self.from_json(json:)
      json[:deletion?] = false
      json[:date] = Time.at(json[:start] / 1000.0).to_date
      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          "#{title} has transcoded -> #{size_before} GB to #{size_after} GB (#{size_ratio})"
        end
      end
  end
end
