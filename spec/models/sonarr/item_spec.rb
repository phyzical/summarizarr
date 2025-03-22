# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sonarr::Item do
  describe '#from_json' do
    subject(:from_json) { described_class.from_json(json:) }

    let(:full_json) do
      JSON.parse(
        File.read('spec/support/sonarr/api/v3/history/since.json', encoding: 'bom|utf-8'),
        symbolize_names: true
      )
    end

    context 'when item is downloadFolderImported' do
      let(:json) { full_json.find { |x| x[:eventType] == 'downloadFolderImported' } }

      it 'runs' do
        expect(from_json.to_h).to match(
          {
            event_type: 'downloadFolderImported',
            languages: 'English',
            series: 'Psych',
            title: 'The Spellingg Bee',
            overview:
              'When what begins as a little competitive sabotage in a regional ' \
                'spelling bee quickly escalates to murder. ' \
                'Shawn and Gus must investigate the mysterious death of the ' \
                '"Spellmaster" at the regional Spelling Bee.',
            series_image: 'https://artworks.thetvdb.com/banners/graphical/79335-g4.jpg',
            deletion?: false,
            quality: 'Bluray-1080p'
          }
        )
      end
    end

    context 'when item is episodeFileDeleted' do
      let(:json) { full_json.find { |x| x[:eventType] == 'episodeFileDeleted' } }

      it 'runs' do
        expect(from_json.to_h).to eq(
          event_type: 'episodeFileDeleted',
          languages: 'English',
          series: 'Psych',
          title: 'The Spellingg Bee',
          overview:
            'When what begins as a little competitive sabotage in a regional ' \
              'spelling bee quickly escalates to murder. ' \
              'Shawn and Gus must investigate the mysterious death of the ' \
              '"Spellmaster" at the regional Spelling Bee.',
          series_image: 'https://artworks.thetvdb.com/banners/graphical/79335-g4.jpg',
          deletion?: true,
          quality: 'SDTV'
        )
      end
    end
  end
end
