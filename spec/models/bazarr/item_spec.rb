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
            File.read("spec/support/requests/bazarr#{Service.episode_history_endpoint}.json", encoding: 'bom|utf-8'),
            symbolize_names: true
          )[
            :data
          ].first
        end

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              series: 'Penn & Teller: Fool Us',
              date: Date.parse('29/03/2025'),
              language: 'English',
              episode_number: '11x10',
              title: 'Gotcha!',
              description: 'English subtitles downloaded from whisperai with a score of 66.94%.',
              score: '66.94%'
            }
          )
        end
      end

      context 'when item is movie' do
        let(:json) do
          JSON.parse(
            File.read("spec/support/requests/bazarr#{Service.movie_history_endpoint}.json", encoding: 'bom|utf-8'),
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
              episode_number: nil,
              date: Date.parse('29/03/2025'),
              title: 'Back in Action',
              description: 'English HI subtitles downloaded from opensubtitlescom with a score of 85.0%.',
              score: '85.0%'
            }
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:bazarr_item, title:, description:) }
      let(:title) { 'test title' }
      let(:description) { 'test description' }

      it 'runs' do
        expect(summary).to eq("#{title}: #{description}")
      end
    end
  end
end
