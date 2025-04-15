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

  describe '#bazarr' do
    subject(:bazarr) { config.bazarr }

    it 'has a default config' do
      expect(bazarr.to_h).to eq(base_url: 'http://bazarr:6767', api_key: '12345')
    end
  end

  describe '#lidarr' do
    subject(:lidarr) { config.lidarr }

    it 'has a default config' do
      expect(lidarr.to_h).to eq(base_url: 'http://lidarr:8686', api_key: '12345')
    end
  end

  describe '#readarr' do
    subject(:readarr) { config.readarr }

    it 'has a default config' do
      expect(readarr.to_h).to eq(base_url: 'http://readarr:8787', api_key: '12345')
    end
  end

  describe '#mylar3' do
    subject(:mylar3) { config.mylar3 }

    it 'has a default config' do
      expect(mylar3.to_h).to eq(base_url: 'http://mylar3:8090', api_key: '12345')
    end
  end

  describe '#tdarr' do
    subject(:tdarr) { config.tdarr }

    it 'has a default config' do
      expect(tdarr.to_h).to eq(base_url: 'http://tdarr:8266', api_key: '')
    end
  end

  describe '#discord' do
    subject(:discord) { config.discord }

    it 'has a default config' do
      expect(discord.to_h).to eq(
        webhook_url: nil,
        enabled?: false,
        username: 'Summarizarr Bot',
        avatar_url: 'https://github.com/phyzical/summarizarr/blob/main/icon.png'
      )
    end
  end

  describe '#from_date' do
    subject(:from_date) { config.from_date }

    it 'has a default config' do
      expect(from_date).to match(7.days.ago.to_date)
    end
  end

  describe '#rerun_datetime' do
    subject(:rerun_datetime) { config.rerun_datetime }

    it 'has a default config' do
      expect(rerun_datetime).to match(DateTime.now + 7.days)
    end
  end

  describe '#removal_regex' do
    subject(:removal_regex) { config.removal_regex }

    it 'has a default config' do
      expect(removal_regex).to match(//i)
    end
  end
end
