# frozen_string_literal: true

require 'spec_helper'

module Readarr
  RSpec.describe Service do
    include MockRequests
    subject(:items) { service.items }

    let(:service) { described_class.new }

    before { stub_readarr }

    it 'returns history only containing expected types and groups by title' do
      expect(items.count).to be(1)
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
end
