# frozen_string_literal: true

require 'spec_helper'
module Radarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read("spec/support/requests/radarr#{Service.history_endpoint}?page=1.json", encoding: 'bom|utf-8'),
          symbolize_names: true
        )[
          :records
        ]
      end

      context 'when item is downloadFolderImported' do
        let(:json) { full_json.find { |x| x[:eventType] == described_class::EVENT_TYPES[:download_folder_imported] } }

        it 'runs' do
          expect(from_json.to_h).to match(
            {
              event_type: described_class::EVENT_TYPES[:download_folder_imported],
              languages: 'Spanish',
              title: 'Back in Action',
              date: Date.parse('29/03/2025'),
              overview:
                'Fifteen years after vanishing from the CIA to start a family, elite ' \
                  'spies Matt and Emily jump back into the world of espionage when their cover is blown.',
              image: 'https://image.tmdb.org/t/p/original/3L3l6LsiLGHkTG4RFB2aBA6BttB.jpg',
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
              title: "Peter Pan's Neverland Nightmare",
              date: Date.parse('28/03/2025'),
              overview:
                'Wendy Darling strikes out in an attempt to rescue her brother Michael from the clutches ' \
                  'of the evil Peter Pan who intends to send him to Neverland. Along the way she meets a ' \
                  'twisted Tinkerbell, who is hooked on what she thinks is fairy dust.',
              image: 'https://image.tmdb.org/t/p/original/mOR1Ks0EcXocwMV4EPv4letz0F5.jpg',
              deletion?: true,
              quality: 'WEBRip-1080p',
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
