# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Summary::Service do
  include MockRequests

  describe '#generate' do
    subject(:generate) { described_class.generate }

    before do
      stub_all
      allow(Sonarr::Service).to receive(:new).and_call_original
      allow(Radarr::Service).to receive(:new).and_call_original
      allow(Lidarr::Service).to receive(:new).and_call_original
      allow(Mylar3::Service).to receive(:new).and_call_original
      allow(Readarr::Service).to receive(:new).and_call_original
      allow(Bazarr::Service).to receive(:new).and_call_original
      allow(Tdarr::Service).to receive(:new).and_call_original
    end

    it 'returns a string' do
      expect(generate).to match(a_string_including(''))
      expect(Sonarr::Service).to have_received(:new)
      expect(Radarr::Service).to have_received(:new)
      expect(Lidarr::Service).to have_received(:new)
      expect(Mylar3::Service).to have_received(:new)
      expect(Readarr::Service).to have_received(:new)
      expect(Bazarr::Service).to have_received(:new)
      expect(Tdarr::Service).to have_received(:new)
    end
  end
end
