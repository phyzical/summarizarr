# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Discord do
    include MockRequests

    before do
      allow(Config.get).to receive(:discord).and_return(Config::NotificationConfig.new(**config))
      stub_request(:post, 'http://fakediscord:443/link/12345').with(
        body: {
          content: anything,
          embeds: anything,
          username: 'username',
          avatar_url: 'https://fakediscord/avatar/12345'
        }.to_json,
        headers: {
          'Accept' => 'application/json',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Content-Type' => 'application/json',
          'Host' => 'fakediscord',
          'User-Agent' => 'Ruby'
        }
      ).to_return(status: 200, body: '', headers: {})
      stub_sonarr
      allow(Sonarr::Service).to receive(:new).and_call_original
    end

    let(:service) { Sonarr::Service.new }

    let(:config) do
      {
        webhook_url: 'https://fakediscord/link/12345',
        enabled?: true,
        username: 'username',
        avatar_url: 'https://fakediscord/avatar/12345'
      }
    end

    describe '.notify' do
      subject(:notify) { described_class.notify(service:) }

      it 'prints the contents' do
        expect { notify }.to output(%r{Requesting https://fakediscord/link/12345}).to_stdout
      end
    end
  end
end
