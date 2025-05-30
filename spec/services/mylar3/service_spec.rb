# frozen_string_literal: true

require 'spec_helper'

module Mylar3
  RSpec.describe Service do
    include MockRequests
    subject(:items) { service.items }

    let(:service) { described_class.new }

    before { stub_mylar3 }

    it 'returns history only containing expected types and groups by title' do
      expect(items.count).to be(2)
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
end
