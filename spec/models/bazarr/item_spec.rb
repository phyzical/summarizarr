# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Bazarr::Item do
  describe '#from_json' do
    subject(:from_json) { described_class.from_json(json:) }

    let(:json) { '' }

    context 'when item is episode' do
      let(:json) do
        JSON.parse(
          File.read('spec/support/requests/bazarr/api/episodes/history.json', encoding: 'bom|utf-8'),
          symbolize_names: true
        )[
          :data
        ].first
      end

      it 'runs' do
        expect(from_json.to_h).to match(
          {
            series: '1923',
            language: 'English',
            episode_number: '2x5',
            title: 'Only Gunshots to Guide Us',
            description: 'English subtitles downloaded from whisperai with a score of 66.94%.',
            date: Date.strptime('23/03/2025', '%d/%m/%Y'),
            score: '66.94%'
          }
        )
      end
    end

    context 'when item is movie' do
      let(:json) do
        JSON.parse(
          File.read('spec/support/requests/bazarr/api/movies/history.json', encoding: 'bom|utf-8'),
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
            title: 'Snow White',
            description: 'English subtitles downloaded from supersubtitles with a score of 75.83%.',
            date: Date.strptime('23/03/2025', '%d/%m/%Y'),
            score: '75.83%'
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
