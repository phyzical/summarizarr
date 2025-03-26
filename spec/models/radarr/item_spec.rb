# frozen_string_literal: true

require 'spec_helper'
module Radarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read("spec/support/requests/radarr#{Service.since_endpoint}.json", encoding: 'bom|utf-8'),
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
              title: 'Greg Davies: Firing Cheeseballs at a Dog',
              overview:
                'Greg Davies, the star of BAFTA-winning TV series and hit film "The Inbetweeners," ' \
                  'presents his own solo show: "Firing Cheeseballs at a Dog."',
              image: 'https://image.tmdb.org/t/p/original/2FoKVOPJ8OoHQUc2nGeJ2X9V0h6.jpg',
              deletion?: false,
              quality: 'WEBDL-1080p',
              old_quality: nil
            }
          )
        end
      end

      context 'when item is movieFileDeleted' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:movie_file_deleted] } }

        it 'runs' do
          expect(from_json.to_h).to eq(
            {
              event_type: described_class::EVENT_TYPES[:movie_file_deleted],
              languages: 'English',
              title: 'Greg Davies: Firing Cheeseballs at a Dog',
              overview:
                'Greg Davies, the star of BAFTA-winning TV series and hit film "The Inbetweeners," ' \
                  'presents his own solo show: "Firing Cheeseballs at a Dog."',
              image: 'https://image.tmdb.org/t/p/original/2FoKVOPJ8OoHQUc2nGeJ2X9V0h6.jpg',
              deletion?: true,
              quality: 'DVD',
              old_quality: nil
            }
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:radarr_item, old_quality:) }

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
