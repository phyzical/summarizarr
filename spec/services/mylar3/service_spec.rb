# frozen_string_literal: true

require 'spec_helper'

module Mylar3
  RSpec.describe Service do
    include MockRequests

    let(:service) { described_class.new }
    let(:total) { 2 }

    before { stub_mylar3 }

    describe '#items' do
      subject(:items) { service.items }

      it 'returns history only containing expected types and groups by title' do
        expect(items.count).to be(total)
        expect(items).to all(be_a(Item::Thing))
      end

      context 'when apps required config is missing' do
        before { allow(Config.get).to receive(:mylar3).and_return(Config::AppConfig.new(**config)) }

        let(:config) { { api_key:, base_url: } }
        let(:base_url) { Faker::Internet.url }
        let(:api_key) { Faker::Internet.password }

        context 'when base_url missing' do
          let(:base_url) { '' }

          it 'alerts and skips' do
            expect { items }.to output(/Mylar3 URL is not set, will be skipped/).to_stdout
          end
        end

        context 'when the wrong / invalid app is found given config' do
          before { stub_fakeserver }

          let(:base_url) { 'http://fakeserver' }

          it 'alerts and skips' do
            expect { items }.to output(/Error this is not an instance of Mylar3/).to_stdout
          end
        end
      end
    end

    describe 'summary' do
      subject(:summary) { service.summary }

      it 'summaries correctly' do
        expect(summary).to eq("* Processed #{total} issues from 1 comics\n")
      end
    end

    describe '#grouped_items' do
      subject(:grouped_items) { service.grouped_items }

      let(:expected_comics) { ['The Walking Dead Deluxe'] }

      it 'groups by comic , then nothing, then date and all are sorted' do
        expect(grouped_items.keys).to match(expected_comics)
        expect(grouped_items[expected_comics.first].keys).to match([described_class::SECONDARY_GROUP_CONTEXT])
        #  groups by date
        expect(grouped_items[expected_comics.first][described_class::SECONDARY_GROUP_CONTEXT].keys).to match(
          ['Mon, 24 Mar 2025', 'Tue, 25 Mar 2025'].map(&:to_date)
        )
        expect(
          grouped_items[expected_comics.first][described_class::SECONDARY_GROUP_CONTEXT][
            'Mon, 24 Mar 2025'.to_date
          ].length
        ).to be(1)
      end
    end
  end
end
