# frozen_string_literal: true

require 'spec_helper'

module Lidarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read("spec/support/requests/lidarr#{Service.history_endpoint}?page=1.json", encoding: 'bom|utf-8'),
          symbolize_names: true
        )[
          :records
        ]
      end

      context 'when item is downloadImported' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:track_file_imported] } }

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              event_type: described_class::EVENT_TYPES[:track_file_imported],
              album: 'Fantasy Remixes',
              artist: 'M83',
              date: Date.parse('28/03/2025'),
              title: 'Fantasy',
              image:
                'http://assets.fanart.tv/fanart/music/6d7b7cd4-254b-4c25-83f6-dd20f98ceacd/artistbackground/m83-505e6f72ddbe3.jpg',
              deletion?: false,
              quality: 'MP3-320',
              old_quality: nil
            }
          )
        end
      end

      context 'when item is trackFileDeleted' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:track_file_deleted] } }

        it 'runs' do
          expect(from_json.to_h).to eq(
            {
              event_type: described_class::EVENT_TYPES[:track_file_deleted],
              album: 'Fantasy Remixes',
              artist: 'M83',
              date: Date.parse('28/03/2025'),
              title: 'Fantasy',
              image:
                'http://assets.fanart.tv/fanart/music/6d7b7cd4-254b-4c25-83f6-dd20f98ceacd/artistbackground/m83-505e6f72ddbe3.jpg',
              deletion?: true,
              quality: 'MP3-320',
              old_quality: nil
            }
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:lidarr_item, old_quality:) }

      let(:old_quality) { nil }

      it 'when no old_quality' do
        expect(summary).to eq("#{item.title} has downloaded at #{item.quality}")
      end

      context 'when old_quality is present' do
        let(:old_quality) { 'MP3-280' }

        it 'runs' do
          expect(summary).to eq("#{item.title} has upgraded from #{item.old_quality} to #{item.quality}")
        end
      end
    end
  end
end
