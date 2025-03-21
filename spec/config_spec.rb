# frozen_string_literal: true

require 'spec_helper'
RSpec.describe Config do
  let(:config) { described_class.get }

  describe '#sonarr' do
    subject(:sonarr) { config.sonarr }

    it 'has a default config' do
      expect(sonarr.to_h).to eq(base_url: 'http://sonarr:8989', api_key: '12345')
    end
  end

  describe '#radarr' do
    subject(:radarr) { config.radarr }

    it 'has a default config' do
      expect(radarr.to_h).to eq(base_url: 'http://radarr:7878', api_key: '12345')
    end
  end

  describe '#from_date' do
    subject(:from_date) { config.from_date }

    it 'has a default config' do
      expect(from_date).to be_within(0.1).of(7.days.ago)
    end
  end
end
