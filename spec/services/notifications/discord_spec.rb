# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Discord do
    include MockRequests

    let(:headers) do
      {
        Accept: 'application/json',
        'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type': 'application/json',
        Host: 'fakediscord',
        'User-Agent': 'Ruby'
      }
    end

    let(:config) do
      {
        webhook_url: 'https://fakediscord/link/12345',
        enabled?: true,
        username: 'username',
        avatar_url: 'https://fakediscord/avatar/12345'
      }
    end

    before do
      allow(Config.get).to receive(:discord).and_return(Config::NotificationConfig.new(**config))
      stub_all
      stub_request(:post, config[:webhook_url]).with(
        body: {
          content: '',
          username: config[:username],
          avatar_url: config[:avatar_url],
          embeds: anything
        },
        headers:
      ).to_return(status: 200, body: '', headers: {})
      allow(Request).to receive(:perform).and_call_original
    end

    describe '.notify' do
      subject(:notify) { described_class.notify(service:) }

      let(:expected_count) do
        #For each service, once for summary, once for each series + season
        i = 1
        service.grouped_items.each { |_, primaries| primaries.each { |_, secondaries| i += secondaries.count } }
        i
      end

      context 'when sonarr' do
        let(:service) { Sonarr::Service.new }

        it 'notifies the summary, one for each primary + secondary combo' do
          notify
          expect(Request).to have_received(:perform)
            .with(url: config[:webhook_url], type: :post, headers: anything, body: anything)
            .exactly(expected_count)
            .times
        end
      end

      context 'when radarr' do
        let(:service) { Radarr::Service.new }

        it 'notifies the summary, one for each primary + secondary combo' do
          notify
          expect(Request).to have_received(:perform)
            .with(url: config[:webhook_url], type: :post, headers: anything, body: anything)
            .exactly(expected_count)
            .times
        end
      end

      context 'when lidarr' do
        let(:service) { Lidarr::Service.new }

        it 'notifies the summary, one for each primary + secondary combo' do
          notify
          expect(Request).to have_received(:perform)
            .with(url: config[:webhook_url], type: :post, headers: anything, body: anything)
            .exactly(expected_count)
            .times
        end
      end

      context 'when readarr' do
        let(:service) { Readarr::Service.new }

        it 'notifies the summary, one for each primary + secondary combo' do
          notify
          expect(Request).to have_received(:perform)
            .with(url: config[:webhook_url], type: :post, headers: anything, body: anything)
            .exactly(expected_count)
            .times
        end
      end

      context 'when bazarr' do
        let(:service) { Bazarr::Service.new }

        it 'notifies the summary, one for each primary + secondary combo' do
          notify
          expect(Request).to have_received(:perform)
            .with(url: config[:webhook_url], type: :post, headers: anything, body: anything)
            .exactly(expected_count)
            .times
        end
      end

      context 'when mylar3' do
        let(:service) { Mylar3::Service.new }

        it 'notifies the summary, one for each primary + secondary combo' do
          notify
          expect(Request).to have_received(:perform)
            .with(url: config[:webhook_url], type: :post, headers: anything, body: anything)
            .exactly(expected_count)
            .times
        end
      end

      context 'when tdarr' do
        let(:service) { Tdarr::Service.new }

        it 'notifies the summary, one for each primary + secondary combo' do
          notify
          expect(Request).to have_received(:perform)
            .with(url: config[:webhook_url], type: :post, headers: anything, body: anything)
            .exactly(expected_count)
            .times
        end
      end
    end
  end
end
