# frozen_string_literal: true

require 'spec_helper'

module Tdarr
  RSpec.describe Service do
    include MockRequests

    let(:service) { described_class.new }

    before { stub_tdarr }

    describe 'items' do
      subject(:items) { service.items }

      it 'returns history only containing expected types and groups by title' do
        expect(items.count).to be(60)
        expect(items).to all(be_a(Item::Thing))
      end

      context 'when apps required config is missing' do
        before { allow(Config.get).to receive(:tdarr).and_return(Config::AppConfig.new(**config)) }

        let(:config) { { api_key:, base_url: } }
        let(:base_url) { Faker::Internet.url }
        let(:api_key) { Faker::Internet.password }

        context 'when base_url missing' do
          let(:base_url) { '' }

          it 'alerts and skips' do
            expect { items }.to output(/Tdarr URL is not set, will be skipped/).to_stdout
          end
        end

        context 'when the wrong / invalid app is found given config' do
          before { stub_fakeserver }

          let(:base_url) { 'http://fakeserver' }

          it 'alerts and skips' do
            expect { items }.to output(/Error this is not an instance of Tdarr/).to_stdout
          end
        end
      end
    end

    describe 'summary' do
      subject(:summary) { service.summary }

      it 'summaries correctly' do
        expect(summary).to eq(
          "* Processed 60 items\n* Starting size: 55.017 GB\n* Ending size: 35.317 GB\n" \
            "* Total Savings: 19.7 GB\n* Average Savings: 0.328 GB\n"
        )
      end
    end
  end
end
