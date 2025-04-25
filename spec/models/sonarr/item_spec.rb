# frozen_string_literal: true

require 'spec_helper'

module Sonarr
  RSpec.describe Item do
    describe '#from_json' do
      subject(:from_json) { described_class.from_json(json:) }

      let(:full_json) do
        JSON.parse(
          File.read("spec/support/requests/sonarr/#{Service.history_endpoint}?page=1.json", encoding: 'bom|utf-8'),
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
              languages: 'English',
              date: Date.parse('29/03/2025'),
              series: 'Penn & Teller: Fool Us',
              season: 11,
              episode: 10,
              title: 'Gotcha!',
              overview:
                'Magicians Vitaly Beckman, AnnaRose Einarsen, Goncalo Gil, and Ren X ' \
                  'try to fool the veteran duo with their illusions.',
              image: 'https://artworks.thetvdb.com/banners/graphical/239851-g.jpg',
              deletion?: false,
              quality: 'WEBDL-1080p',
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
            series: 'Dateline: Secrets Uncovered',
            date: Date.parse('28/03/2025'),
            title: 'The Road Trip',
            season: 14,
            episode: 20,
            overview:
              'When Dr. Teresa Sievers is found murdered in her kitchen, detectives struggle to find any ' \
                'leads until an unexpected tip changes everything; the woman who helped investigators speaks out.',
            image: 'https://artworks.thetvdb.com/banners/v4/series/332213/banners/673648afe76e9.jpg',
            deletion?: false,
            quality: 'WEBDL-480p',
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
        expect(summary).to eq("Ep: #{item.episode} - #{item.title} has downloaded at #{item.quality}")
      end

      context 'when old_quality is present' do
        let(:old_quality) { 'DVD' }

        it 'runs' do
          expect(summary).to eq(
            "Ep: #{item.episode} - #{item.title} has upgraded from #{item.old_quality} to #{item.quality}"
          )
        end
      end
    end
  end
end
