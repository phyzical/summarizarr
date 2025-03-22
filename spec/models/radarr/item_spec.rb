# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Radarr::Item do
  describe '#from_json' do
    subject(:from_json) { described_class.from_json(json:) }

    let(:full_json) do
      JSON.parse(
        File.read('spec/support/requests/radarr/api/v3/history/since.json', encoding: 'bom|utf-8'),
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
            title: 'Greg Davies: Firing Cheeseballs at a Dog',
            overview:
              'Greg Davies, the star of BAFTA-winning TV series and hit film "The Inbetweeners," ' \
                'presents his own solo show: "Firing Cheeseballs at a Dog."',
            image: 'https://image.tmdb.org/t/p/original/2FoKVOPJ8OoHQUc2nGeJ2X9V0h6.jpg',
            deletion?: false,
            quality: 'WEBDL-1080p'
          }
        )
      end
    end

    context 'when item is movieFileDeleted' do
      let(:json) { full_json.find { |x| x[:eventType] == 'movieFileDeleted' } }

      it 'runs' do
        expect(from_json.to_h).to eq(
          {
            event_type: 'movieFileDeleted',
            languages: 'English',
            title: 'Greg Davies: Firing Cheeseballs at a Dog',
            overview:
              'Greg Davies, the star of BAFTA-winning TV series and hit film "The Inbetweeners," ' \
                'presents his own solo show: "Firing Cheeseballs at a Dog."',
            image: 'https://image.tmdb.org/t/p/original/2FoKVOPJ8OoHQUc2nGeJ2X9V0h6.jpg',
            deletion?: true,
            quality: 'DVD'
          }
        )
      end
    end
  end
end
