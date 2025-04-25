# frozen_string_literal: true

require 'spec_helper'

module Sonarr
  RSpec.describe Service do
    include MockRequests

    let(:service) { described_class.new }
    let(:total) { 24 }

    before { stub_sonarr }

    describe '#items' do
      subject(:items) { service.items }

      it 'returns history only containing expected types and groups by title' do
        expect(items.count).to be(total)
        expect(items).to all(be_a(Item::Thing))
      end

      context 'when apps required config is missing' do
        before { allow(Config.get).to receive(:sonarr).and_return(Config::AppConfig.new(**config)) }

        let(:config) { { api_key:, base_url: } }
        let(:base_url) { Faker::Internet.url }
        let(:api_key) { Faker::Internet.password }

        context 'when base_url missing' do
          let(:base_url) { '' }

          it 'alerts and skips' do
            expect { items }.to output(/Sonarr URL is not set, will be skipped/).to_stdout
          end
        end

        context 'when the wrong / invalid app is found given config' do
          before { stub_fakeserver }

          let(:base_url) { 'http://fakeserver' }

          it 'alerts and skips' do
            expect { items }.to output(/Error this is not an instance of Sonarr/).to_stdout
          end
        end
      end
    end

    describe 'summary' do
      subject(:summary) { service.summary }

      it 'summaries correctly' do
        expect(summary).to eq("* Processed #{total} episodes from 6 series\n")
      end
    end

    describe '#grouped_items' do
      subject(:grouped_items) { service.grouped_items }

      let(:expected_series) do
        [
          'Dateline: Secrets Uncovered',
          'Gogglebox',
          'Great British Menu',
          'Penn & Teller: Fool Us',
          "RuPaul's Drag Race",
          'Younger'
        ]
      end

      it 'groups by series, then season, then date and all are sorted' do
        expect(grouped_items.keys).to match(expected_series)
        # shows group by series
        expect(grouped_items[expected_series.first].keys).to match([14])
        #  groups by date
        expect(grouped_items[expected_series.first][14].keys).to match(['Fri, 28 Mar 2025'].map(&:to_date))
        expect(grouped_items[expected_series.first][14]['Fri, 28 Mar 2025'.to_date].length).to be(1)
      end
    end
  end
end
