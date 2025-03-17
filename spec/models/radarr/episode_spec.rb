# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Radarr::Episode do
  describe '#from_json' do
    subject(:from_json) { described_class.from_json(json:) }

    let(:full_json) do
      JSON.parse(
        File.read('spec/support/radarr/api/v3/history/since.json', encoding: 'bom|utf-8'),
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
            title: 'Avengers: Infinity War',
            overview:
              'As the Avengers and their allies have continued to protect the world from threats too large for' \
                ' any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. A despot of ' \
                'intergalactic infamy, his goal is to collect all six Infinity Stones, artifacts of unimaginable ' \
                'power, and use them to inflict his twisted will on all of reality. Everything the Avengers have ' \
                'fought for has led up to this moment - the fate of Earth and existence itself ' \
                'has never been more uncertain.',
            image: 'https://image.tmdb.org/t/p/original/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
            upgrade?: false,
            quality: 'Unknown'
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
            title: 'Avengers: Infinity War',
            overview:
              'As the Avengers and their allies have continued to protect the world from threats too large for ' \
                'any one hero to handle, a new danger has emerged from the cosmic shadows: Thanos. A despot of ' \
                'intergalactic infamy, his goal is to collect all six Infinity Stones, artifacts of unimaginable ' \
                'power, and use them to inflict his twisted will on all of reality. Everything the Avengers have ' \
                'fought for has led up to this moment - the fate of Earth and existence itself has never ' \
                'been more uncertain.',
            image: 'https://image.tmdb.org/t/p/original/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg',
            upgrade?: false,
            quality: 'WEBDL-1080p'
          }
        )
      end
    end
  end
end
