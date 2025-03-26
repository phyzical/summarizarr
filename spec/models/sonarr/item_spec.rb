# frozen_string_literal: true

require 'spec_helper'

module Sonarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read("spec/support/requests/sonarr/#{Service.since_endpoint}.json", encoding: 'bom|utf-8'),
          symbolize_names: true
        )
      end

      context 'when item is downloadFolderImported' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:download_folder_imported] } }

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              event_type: described_class::EVENT_TYPES[:download_folder_imported],
              languages: 'English',
              series: 'Psych',
              title: 'The Spellingg Bee',
              overview:
                'When what begins as a little competitive sabotage in a regional ' \
                  'spelling bee quickly escalates to murder. ' \
                  'Shawn and Gus must investigate the mysterious death of the ' \
                  '"Spellmaster" at the regional Spelling Bee.',
              image: 'https://artworks.thetvdb.com/banners/graphical/79335-g4.jpg',
              deletion?: false,
              quality: 'Bluray-1080p',
              old_quality: nil
            }
          )
        end
      end

      context 'when item is episodeFileDeleted' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:episode_file_deleted] } }

        it 'runs' do
          expect(from_json.to_h).to eq(
            event_type: described_class::EVENT_TYPES[:episode_file_deleted],
            languages: 'English',
            series: 'Psych',
            title: 'The Spellingg Bee',
            overview:
              'When what begins as a little competitive sabotage in a regional ' \
                'spelling bee quickly escalates to murder. ' \
                'Shawn and Gus must investigate the mysterious death of the ' \
                '"Spellmaster" at the regional Spelling Bee.',
            image: 'https://artworks.thetvdb.com/banners/graphical/79335-g4.jpg',
            deletion?: true,
            quality: 'SDTV',
            old_quality: nil
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:sonarr_item, old_quality:) }

      let(:old_quality) { nil }

      it 'when no old_quality' do
        expect(summary).to eq("#{item.title} has downloaded at #{item.quality}")
      end

      context 'when old_quality is present' do
        let(:old_quality) { 'DVD' }

        it 'runs' do
          expect(summary).to eq("#{item.title} has upgraded from #{item.old_quality} to #{item.quality}")
        end
      end
    end
  end
end
