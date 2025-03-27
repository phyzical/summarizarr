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
              album: 'The World of Hans Zimmer - Part II: A New Dimension',
              artist: 'Hans Zimmer',
              track:
                '01-hans_zimmer_lucy_landymore_luis_ribeiro_odessa_orchestra_and_friends_gavin_greenaway-man_of_steel_what_are_you_g-520a3c53', # rubocop:disable Layout/LineLength
              title:
                '01-hans_zimmer_lucy_landymore_luis_ribeiro_odessa_orchestra_and_friends_gavin_greenaway-man_of_steel_what_are_you_g-520a3c53', # rubocop:disable Layout/LineLength
              image:
                'http://assets.fanart.tv/fanart/music/e6de1f3b-6484-491c-88dd-6d619f142abc/artistbackground/zimmer-hans-52241079c6a60.jpg',
              deletion?: false,
              quality: 'MP3-320',
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
              album: 'The World of Hans Zimmer - Part II: A New Dimension',
              artist: 'Hans Zimmer',
              track:
                '20-hans_zimmer_lisa_gerrard_gan-ya_ben-gur_akselrod_odessa_orchestra_and_friends_gavin_greenaway-gladiator_suite__p-da4e66c6', # rubocop:disable Layout/LineLength
              title:
                '20-hans_zimmer_lisa_gerrard_gan-ya_ben-gur_akselrod_odessa_orchestra_and_friends_gavin_greenaway-gladiator_suite__p-da4e66c6', # rubocop:disable Layout/LineLength
              image:
                'http://assets.fanart.tv/fanart/music/e6de1f3b-6484-491c-88dd-6d619f142abc/artistbackground/zimmer-hans-52241079c6a60.jpg',
              deletion?: true,
              quality: 'MP3-280',
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
