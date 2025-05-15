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
              date: 'Sat, 26 Apr 2025'.to_date,
              file: '/mnt/media/Tv Shows/The Pitt/Season 1/The.Pitt.S01E14.8-00.P.M.mkv',
              season: 1,
              title: 'The.Pitt.S01E14.8-00.P.M.mkv',
              series: 'The Pitt',
              size_after: 0.93,
              size_before: 1.222,
              size_ratio: '76.16%',
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
