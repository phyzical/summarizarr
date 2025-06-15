# frozen_string_literal: true

require 'spec_helper'

module Lidarr
  RSpec.describe Service do
    include MockRequests

    let(:service) { described_class.new }
    let(:total) { 35 }

    before { stub_lidarr }

    describe '#items' do
      subject(:items) { service.items }

      it 'returns history only containing expected types and groups by title' do
        expect(items.count).to be(total)
        expect(items).to all(be_a(Item::Thing))
      end

      context 'when apps required config is missing' do
        before { allow(Config.get).to receive(:lidarr).and_return(Config::AppConfig.new(**config)) }

        let(:config) { { api_key:, base_url: } }
        let(:base_url) { Faker::Internet.url }
        let(:api_key) { Faker::Internet.password }

        context 'when base_url missing' do
          let(:base_url) { '' }

          it 'alerts and skips' do
            expect { items }.to output(/Lidarr URL is not set, will be skipped/).to_stdout
          end
        end

        context 'when the wrong / invalid app is found given config' do
          before { stub_fakeserver }

          let(:base_url) { 'http://fakeserver' }

          it 'alerts and skips' do
            expect { items }.to output(/Error this is not an instance of Lidarr/).to_stdout
          end
        end
      end
    end

    describe 'summary' do
      subject(:summary) { service.summary }

      it 'summaries correctly' do
        expect(summary).to eq("* Processed #{total} songs from 3 artists\n")
      end
    end

    describe '#grouped_items' do
      subject(:grouped_items) { service.grouped_items }

      let(:expected_artists) { ['Above & Beyond', 'Hans Zimmer', 'M83'] }

      it 'groups by artist , then album, then date and all are sorted' do
        expect(grouped_items.keys).to match(expected_artists)
        expect(grouped_items[expected_artists.first].keys).to match(['Crazy Love (ANUQRAM remix)'])
        #  groups by date
        expect(grouped_items[expected_artists.first]['Crazy Love (ANUQRAM remix)'].length).to be(3)
      end
    end
  end
end
