# frozen_string_literal: true

require 'spec_helper'

module Bazarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:json) { '' }

      context 'when item is episode' do
        let(:json) do
          JSON.parse(
            File.read(
              "spec/support/requests/bazarr#{Service.episode_history_endpoint}?start=0.json",
              encoding: 'bom|utf-8'
            ),
            symbolize_names: true
          )[
            :data
          ].first
        end

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              series: 'Keeping Up with the Kardashians',
              date: 'Sat, 26 Apr 2025'.to_date,
              language: 'English',
              episode: 18,
              season: 8,
              title: 'All Signs Point to North',
              description: 'English HI subtitles downloaded from whisperai with a score of 66.94%.',
              score: '66.94%'
            }
          )
        end
      end

      context 'when item is movie' do
        let(:json) do
          JSON.parse(
            File.read(
              "spec/support/requests/bazarr#{Service.movie_history_endpoint}?start=0.json",
              encoding: 'bom|utf-8'
            ),
            symbolize_names: true
          )[
            :data
          ].first
        end

        it 'runs' do
          expect(from_json.to_h).to eq(
            {
              series: nil,
              language: 'English',
              episode: nil,
              season: nil,
              date: 'Fri, 25 Apr 2025'.to_date,
              title: 'Companion',
              description: 'English subtitles downloaded from opensubtitlescom with a score of 85.83%.',
              score: '85.83%'
            }
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:bazarr_item) }

      it 'runs' do
        expect(summary).to eq("Ep: #{item.episode} - #{item.title}: #{item.description}")
      end

      context 'when episode is nil' do
        let(:item) { build(:bazarr_item, episode: nil) }

        it 'runs' do
          expect(summary).to eq("#{item.title}: #{item.description}")
        end
      end
    end
  end
end
