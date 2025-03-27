# frozen_string_literal: true

require 'spec_helper'

module Readarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read("spec/support/requests/readarr#{Service.since_endpoint}.json", encoding: 'bom|utf-8'),
          symbolize_names: true
        )
      end

      context 'when item is downloadImported' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:book_file_imported] } }

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              event_type: described_class::EVENT_TYPES[:book_file_imported],
              author: 'Brandon Sanderson',
              title: 'Brandon Sanderson - Cosmere - Tress of the Emerald Sea (retail) (epub)',
              image:
                'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/authors/1394044556i/38550.jpg',
              deletion?: false,
              quality: 'EPUB',
              old_quality: nil
            }
          )
        end
      end

      context 'when item is movieFileDeleted' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:book_file_deleted] } }

        it 'runs' do
          expect(from_json.to_h).to eq(
            {
              event_type: described_class::EVENT_TYPES[:book_file_deleted],
              author: 'Brandon Sanderson',
              title: 'asdasdasdasdad Sanderson - Cosmere - Tress of the Emerald Sea (retail) (epub)',
              image:
                'https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/authors/1394044556i/38550.jpg',
              deletion?: true,
              quality: 'EPUB',
              old_quality: nil
            }
          )
        end
      end
    end

    describe '#summary' do
      subject(:summary) { item.summary }

      let(:item) { build(:readarr_item, old_quality:) }

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
