# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Service do
    include MockRequests

    before do
      allow(Config.get).to receive(:discord).and_return(Config::NotificationConfig.new(**config))
      allow(Discord).to receive(:notify).and_return(true)
      allow(Generic).to receive(:notify).and_return(true)
      stub_all
      allow(Sonarr::Service).to receive(:new).and_return(sonarr)
      allow(Radarr::Service).to receive(:new).and_return(radarr)
      allow(Lidarr::Service).to receive(:new).and_return(lidarr)
      allow(Mylar3::Service).to receive(:new).and_return(mylar3)
      allow(Readarr::Service).to receive(:new).and_return(readarr)
      allow(Bazarr::Service).to receive(:new).and_return(bazarr)
      allow(Tdarr::Service).to receive(:new).and_return(tdarr)
    end

    let(:sonarr) { Sonarr::Service.new }
    let(:radarr) { Radarr::Service.new }
    let(:lidarr) { Lidarr::Service.new }
    let(:mylar3) { Mylar3::Service.new }
    let(:readarr) { Readarr::Service.new }
    let(:bazarr) { Bazarr::Service.new }
    let(:tdarr) { Tdarr::Service.new }

    let(:config) { { webhook_url: Faker::Internet.url, enabled?: true } }

    describe '.notify' do
      subject(:notify) { described_class.notify }

      context 'when discord is enabled' do
        it 'calls Discord::Notification.notify' do
          notify
          Summary::Service::SERVICES.each do |service|
            expect(Discord).to have_received(:notify).with(service: service.new)
          end
        end
      end

      context 'when discord is disabled' do
        let(:config) { { webhook_url: nil, enabled?: false } }

        it 'calls Generic::Notification.notify' do
          notify
          Summary::Service::SERVICES.each do |service|
            expect(Generic).to have_received(:notify).with(service: service.new)
          end
        end
      end
    end
  end
end
