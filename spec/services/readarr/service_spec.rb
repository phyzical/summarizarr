# frozen_string_literal: true

require 'spec_helper'

module Readarr
  RSpec.describe Service do
    include MockRequests

    let(:service) { described_class.new }
    let(:total) { 2 }
    let(:total_upgrades) { 0 }

    before { stub_readarr }

    describe '#items' do
      subject(:items) { service.items }

      it 'returns history only containing expected types and groups by title' do
        expect(items.count).to be(total)
        expect(items).to all(be_a(Item::Thing))
      end

      context 'when apps required config is missing' do
        before { allow(Config.get).to receive(:readarr).and_return(Config::AppConfig.new(**config)) }

        let(:config) { { api_key:, base_url: } }
        let(:base_url) { Faker::Internet.url }
        let(:api_key) { Faker::Internet.password }

        context 'when base_url missing' do
          let(:base_url) { '' }

          it 'alerts and skips' do
            expect { items }.to output(/Readarr URL is not set, will be skipped/).to_stdout
          end
        end

        context 'when the wrong / invalid app is found given config' do
          before { stub_fakeserver }

          let(:base_url) { 'http://fakeserver' }

          it 'alerts and skips' do
            expect { items }.to output(/Error this is not an instance of Readarr/).to_stdout
          end
        end
      end
    end

    describe 'summary' do
      subject(:summary) { service.summary }

      it 'summaries correctly' do
        expect(summary).to eq("* Processed #{total} books from 1 authors\n* Total Upgrades: #{total_upgrades}")
      end
    end

    describe '#grouped_items' do
      subject(:grouped_items) { service.grouped_items }

      let(:expected_authors) { ['Brandon Sanderson'] }

      it 'groups by comic , then nothing, then date and all are sorted' do
        expect(grouped_items.keys).to match(expected_authors)
        expect(grouped_items[expected_authors.first].keys).to match([described_class::SECONDARY_GROUP_CONTEXT])
        #  groups by date
        expect(grouped_items[expected_authors.first][described_class::SECONDARY_GROUP_CONTEXT].length).to be(2)
      end
    end
  end
end
