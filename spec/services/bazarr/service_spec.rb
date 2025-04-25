# frozen_string_literal: true

require 'spec_helper'

module Bazarr
  RSpec.describe Service do
    include MockRequests

    let(:service) { described_class.new }

    before { stub_bazarr }

    describe '#items' do
      subject(:items) { service.items }

      it 'returns history only containing expected types and groups by title' do
        expect(items.count).to be(232)
        expect(items).to all(be_a(Item::Thing))
      end

      context 'when apps required config is missing' do
        before { allow(Config.get).to receive(:bazarr).and_return(Config::AppConfig.new(**config)) }

        let(:config) { { api_key:, base_url: } }
        let(:base_url) { Faker::Internet.url }
        let(:api_key) { Faker::Internet.password }

        context 'when base_url missing' do
          let(:base_url) { '' }

          it 'alerts and skips' do
            expect { items }.to output(/Bazarr URL is not set, will be skipped/).to_stdout
          end
        end

        context 'when the wrong / invalid app is found given config' do
          before { stub_fakeserver }

          let(:base_url) { 'http://fakeserver' }

          it 'alerts and skips' do
            expect { items }.to output(/Error this is not an instance of Bazarr/).to_stdout
          end
        end
      end

      describe '#grouped_items' do
        subject(:grouped_items) { service.grouped_items }

        let(:expected_series) do
          [
            nil,
            '1923',
            '9-1-1',
            "A Young Doctor's Notebook",
            'American Dad!',
            'Blacktalon',
            'Chicago Fire',
            'Daredevil: Born Again',
            'Dateline: Secrets Uncovered',
            "David Attenborough's Natural Curiosities",
            'Doctor Odyssey',
            'Drunk History',
            'Family Guy',
            'Gardening Australia',
            'Gogglebox',
            'Gogglebox Australia',
            'Good Cop/Bad Cop',
            'Gotham',
            'Grand Designs',
            'Great British Menu',
            "Grey's Anatomy",
            'Kitchen Nightmares (US)',
            'Mom',
            'My Wife and Kids',
            'Mythic Quest',
            'NCIS',
            'Naruto',
            'Penn & Teller: Fool Us',
            'Playgrounds of the Rich and Famous',
            'Power Book III: Raising Kanan',
            'QI',
            'Reacher',
            'Resurrection',
            "RuPaul's Drag Race",
            'Scandal (2012)',
            'Sons of Anarchy',
            'Space Invaders',
            'SpongeBob SquarePants',
            'St. Denis Medical',
            'Stillwater',
            'Taskmaster (AU)',
            'Teen Mom: The Next Chapter',
            'The Catch',
            'The Equalizer (2021)',
            'The Kardashians',
            'The Lazarus Project',
            'The Man in the High Castle',
            'The Neighborhood',
            'The Repair Shop',
            'The Rookie',
            'The Wheel of Time',
            'The White Lotus',
            'Tracker (2024)',
            'Undone',
            'Watson',
            'Yellowjackets',
            'Younger'
          ]
        end

        it 'groups by series or nil for movies, then season, then date and all are sorted' do
          expect(grouped_items.keys).to match(expected_series)
          # movies don't have season
          expect(grouped_items[expected_series.first].keys).to match([nil])
          #  groups by date
          expect(grouped_items[expected_series.first][nil].keys).to match(
            ['Sun, 23 Mar 2025', 'Mon, 24 Mar 2025', 'Tue, 25 Mar 2025', 'Fri, 28 Mar 2025', 'Sat, 29 Mar 2025'].map(
              &:to_date
            )
          )
          expect(grouped_items[expected_series.first][nil]['Mon, 24 Mar 2025'.to_date].length).to be(6)

          # shows group by series
          expect(grouped_items[expected_series.second].keys).to match([2])
          #  groups by date
          expect(grouped_items[expected_series.second][2].keys).to match(['Sun, 23 Mar 2025'].map(&:to_date))
          expect(grouped_items[expected_series.second][2]['Sun, 23 Mar 2025'.to_date].length).to be(1)
        end
      end
    end
  end
end
