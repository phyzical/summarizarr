# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sonarr::Episode do
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
            languages: 'English, French',
            series: 'Comedy Bang! Bang!',
            title: 'T-Pain Wears Shredded Jeans and a Printed Shirt',
            overview:
              'T-Pain, Scott and Weird Al collaborate on a song; and Melvin Alberts talks about being abducted ' \
                'by aliens. Later, Scott\'s scientific breakthrough allows him to get more stuff done; ' \
                'and Weird Al previews his new foodie-TV show.',
            series_image: 'https://artworks.thetvdb.com/banners/graphical/258310-g.jpg',
            upgrade?: false,
            quality: 'WEBDL-1080p'
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
          series: 'Comedy Bang! Bang!',
          title: 'T-Pain Wears Shredded Jeans and a Printed Shirt',
          overview:
            'T-Pain, Scott and Weird Al collaborate on a song; and Melvin Alberts talks about being abducted by ' \
              'aliens. Later, Scott\'s scientific breakthrough allows him to get more stuff done; ' \
              'and Weird Al previews his new foodie-TV show.',
          series_image: 'https://artworks.thetvdb.com/banners/graphical/258310-g.jpg',
          upgrade?: true,
          quality: 'HDTV-720p'
        )
      end
    end
  end
end
