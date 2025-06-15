# frozen_string_literal: true

module Tdarr
  module Item
    EVENT_TYPES = { transcode_success: 'Transcode success' }.freeze

    ATTRIBUTES = {
      status: :event_type,
      fileSizeStartGB: :size_before,
      fileSizeEndGB: :size_after,
      fileSizeRatio: :size_ratio,
      file: :file,
      title: :title,
      series: :series,
      season: :season,
      deletion?: :deletion?,
      date: :date
    }.freeze

    def self.from_json(json:) # rubocop:disable Metrics/AbcSize
      json[:deletion?] = false
      json[:date] = Time.zone.at(json[:start] / 1000.0).to_date
      json[:fileSizeStartGB] = json[:fileSizeStartGB].to_f.round(3)
      json[:fileSizeEndGB] = json[:fileSizeEndGB].to_f.round(3)
      json[:fileSizeRatio] = "#{json[:fileSizeRatio]}%"
      json[:title] = json[:file].split('/').last

      if json[:file].include?('Season')
        splits = json[:file].split(%r{/season }i)
        json[:series] = splits.first.split('/').last
        json[:season] = splits.last.split('/').first.to_i
      end

      Thing.new(**json.slice(*ATTRIBUTES.keys).transform_keys { |k| ATTRIBUTES[k] })
    end

    Thing =
      Struct.new(*ATTRIBUTES.values) do
        def summary
          "#{title} has transcoded -> #{size_before} GB to #{size_after} GB (#{size_ratio})"
        end

        def upgrade?
          false
        end
      end
  end
end
