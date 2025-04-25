# frozen_string_literal: true

require 'spec_helper'

module Tdarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read("spec/support/requests/tdarr/#{Service.jobs_endpoint}?page=0.json", encoding: 'bom|utf-8'),
          symbolize_names: true
        )[
          :array
        ]
      end

      context 'when item' do
        let(:json) { full_json.first }

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              event_type: described_class::EVENT_TYPES[:transcode_success],
              date: Date.parse('31/03/2025'),
              file: '/mnt/media/Tv Shows/The Vicar of Dibley/Season 3/The.Vicar.of.Dibley.S03E04.Summer.mkv',
              season: 3,
              series: 'The Vicar of Dibley',
              size_after: 0.314,
              size_before: 0.464,
              size_ratio: '67.58%',
              deletion?: false
            }
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:tdarr_item) }

      it 'summary' do
        expect(summary).to eq(
          "#{item.title} has transcoded -> #{item.size_before} GB to #{item.size_after} GB (#{item.size_ratio})"
        )
      end
    end
  end
end
