# frozen_string_literal: true

require 'spec_helper'
RSpec.describe Config do
  let(:config) { described_class.get }

  describe '#sonarr' do
    subject(:sonarr) { config.sonarr }

    it 'has a default config' do
      expect(sonarr.to_h).to eq(base_url: 'http://sonarr:8989', api_key: '12345', extra_info: 'false')
      expect(sonarr.extra_info?).to be false
    end

    context 'when we provide true for extra_info' do
      before do
        allow(ENV).to receive(:fetch).with(anything, anything).and_call_original
        allow(ENV).to receive(:fetch).with('SONARR_EXTRA_INFO', 'false').and_return('true')
      end

      it 'has extra_info? set to true' do
        expect(sonarr.extra_info?).to be true
      end
    end
  end

  describe '#radarr' do
    subject(:radarr) { config.radarr }

    it 'has a default config' do
      expect(radarr.to_h).to eq(base_url: 'http://radarr:7878', api_key: '12345', extra_info: 'false')
    end
  end

  describe '#bazarr' do
    subject(:bazarr) { config.bazarr }

    it 'has a default config' do
      expect(bazarr.to_h).to eq(base_url: 'http://bazarr:6767', api_key: '12345', extra_info: 'false')
    end
  end

  describe '#lidarr' do
    subject(:lidarr) { config.lidarr }

    it 'has a default config' do
      expect(lidarr.to_h).to eq(base_url: 'http://lidarr:8686', api_key: '12345', extra_info: 'false')
    end
  end

  describe '#readarr' do
    subject(:readarr) { config.readarr }

    it 'has a default config' do
      expect(readarr.to_h).to eq(base_url: 'http://readarr:8787', api_key: '12345', extra_info: 'false')
    end
  end

  describe '#mylar3' do
    subject(:mylar3) { config.mylar3 }

    it 'has a default config' do
      expect(mylar3.to_h).to eq(base_url: 'http://mylar3:8090', api_key: '12345', extra_info: 'false')
    end
  end

  describe '#tdarr' do
    subject(:tdarr) { config.tdarr }

    it 'has a default config' do
      expect(tdarr.to_h).to eq(base_url: 'http://tdarr:8266', api_key: '', extra_info: 'false')
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

  describe '#debug?' do
    subject(:debug) { config.debug? }

    it 'is false by default' do
      expect(debug).to be false
    end

    context 'when ENV["DEBUG"] is set' do
      before { allow(ENV).to receive(:fetch).with('DEBUG', 'false').and_return('true') }

      it 'is true' do
        expect(debug).to be true
      end
    end
  end

  describe '#notify_upgraded_items?' do
    subject(:notify_upgraded_items) { config.notify_upgraded_items? }

    it 'is true by default' do
      expect(notify_upgraded_items).to be true
    end

    context 'when ENV["ENABLE_UPGRADED_ITEMS"] is set to false' do
      before { allow(ENV).to receive(:fetch).with('ENABLE_UPGRADED_ITEMS', 'true').and_return('false') }

      it 'is false' do
        expect(notify_upgraded_items).to be false
      end
    end
  end

  describe '#rerun_datetime' do
    subject(:rerun_datetime) { config.rerun_datetime }

    it 'has a default config' do
      expect(rerun_datetime).to be_nil
    end

    context 'when ENV["RERUN_INTERVAL_DAYS"] is set' do
      before { allow(ENV).to receive(:fetch).with('RERUN_INTERVAL_DAYS', '').and_return('7') }

      it 'has a date' do
        expect(rerun_datetime).to match(DateTime.now + 7.days)
      end
    end
  end
end
