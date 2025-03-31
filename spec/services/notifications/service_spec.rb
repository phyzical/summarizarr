# frozen_string_literal: true

require 'spec_helper'

module Notifications
  RSpec.describe Service do
    before do
      allow(Config.get).to receive(:discord).and_return(Config::NotificationConfig.new(**config))
      allow(Discord).to receive(:notify).and_return(true)
      allow(Generic).to receive(:notify).and_return(true)
    end

    let(:config) { { webhook_url: Faker::Internet.url, enabled?: true } }

    describe '.notify' do
      subject(:notify) { described_class.notify(contents:) }

      let(:contents) { 'test' }

      context 'when discord is enabled' do
        it 'calls Discord::Notification.notify' do
          notify
          expect(Discord).to have_received(:notify).with(contents:)
        end
      end

      context 'when discord is disabled' do
        let(:config) { { webhook_url: nil, enabled?: false } }

        it 'calls Generic::Notification.notify' do
          notify
          expect(Generic).to have_received(:notify).with(contents:)
        end
      end
    end
  end
end
