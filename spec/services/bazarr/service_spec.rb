# frozen_string_literal: true

require 'spec_helper'

module Bazarr
  RSpec.describe Service do
    include MockRequests

    let(:service) { described_class.new }
    let(:total) { 115 }

    before { stub_bazarr }

    describe '#items' do
      subject(:items) { service.items }

      it 'returns history only containing expected types and groups by title' do
        expect(items.count).to be(total)
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

          context 'when 500' do
            before { stub_fakeserver(status: 500) }

            it 'alerts and skips' do
              expect { items }.to output(/Error this is not an instance of Bazarr/).to_stdout
            end
          end
        end
      end

      describe 'summary' do
        subject(:summary) { service.summary }

        it 'summaries correctly' do
          expect(summary).to eq("* Processed #{total} subtitles\n")
        end
      end

      describe '#grouped_items' do
        subject(:grouped_items) { service.grouped_items }

        let(:expected_series) do
          [
            nil,
            'CSI: Crime Scene Investigation',
            'Fire Country',
            'Gogglebox',
            'Keeping Up with the Kardashians',
            'The IT Crowd',
            'The Pitt',
            "You're the Worst"
          ]
        end

        it 'groups by series or nil for movies, then season, then date and all are sorted' do
          expect(grouped_items.keys).to match(expected_series)
          # movies don't have season
          expect(grouped_items[expected_series.first].keys).to match([nil])
          #  groups by date
          expect(grouped_items[expected_series.first][nil].keys).to match(
            [
              'Sun, 23 Mar 2025',
              'Mon, 24 Mar 2025',
              'Tue, 25 Mar 2025',
              'Fri, 28 Mar 2025',
              'Sat, 29 Mar 2025',
              'Fri, 04 Apr 2025',
              'Sun, 06 Apr 2025',
              'Tue, 08 Apr 2025',
              'Wed, 09 Apr 2025',
              'Fri, 11 Apr 2025',
              'Tue, 15 Apr 2025',
              'Sat, 19 Apr 2025',
              'Tue, 22 Apr 2025',
              'Fri, 25 Apr 2025'
            ].map(&:to_date)
          )
          expect(grouped_items[expected_series.first][nil]['Mon, 24 Mar 2025'.to_date].length).to be(6)

          # shows group by series
          expect(grouped_items[expected_series.second].keys).to match([15])
          #  groups by date
          expect(grouped_items[expected_series.second][15].keys).to match(['Sat, 26 Apr 2025'].map(&:to_date))
          expect(grouped_items[expected_series.second][15]['Sat, 26 Apr 2025'.to_date].length).to be(17)
        end
      end
    end
  end
end
