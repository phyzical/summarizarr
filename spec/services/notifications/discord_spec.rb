# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Discord do
    subject(:service) { described_class }

    before { allow(Config.get).to receive(:discord).and_return(Config::NotificationConfig.new(**config)) }

    let(:contents) { { message: 'Test message' } }

    let(:config) do
      {
        webhook_url: 'https://fakediscord/link/12345',
        enabled?: true,
        username: 'username',
        avatar_url: 'https://fakediscord/avatar/12345'
      }
    end

    describe '.notify' do
      subject(:notify) { service.notify(contents:) }
      it 'prints the contents' do
        expect { notify }.to output(/Test message/).to_stdout
      end
    end
  end
end
